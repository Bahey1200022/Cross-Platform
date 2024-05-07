// ignore_for_file: camel_case_types, avoid_print, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/widgets/post_card.dart';
import 'package:sarakel/Widgets/profiles/communityprofile_page.dart';
import 'package:sarakel/loading_func/loadposts.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/models/post.dart';
import 'package:sarakel/models/user.dart';
import 'package:sarakel/user_profile/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sarakel/features/search_bar/search_control.dart';

///Search delegate class for the search bar
///searching for users posts and communities
class sarakelSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchSuggestions(query), // Pass the query to the API call
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final suggestionList = snapshot.data!;
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString('token');
                query = suggestionList[index]['name'];
                var Type = suggestionList[index]['Type'];
                print(query);
                // Navigate to the desired page
                if (Type == 'Community') {
                  Community community = Community(
                    id: suggestionList[index]['_id'] ?? "",
                    name: suggestionList[index]['communityName'] ?? "",
                    description: suggestionList[index]['description'] ??
                        'Sarakel Community',
                    backimage: suggestionList[index]['backgroundPicUrl'] ??
                        suggestionList[index]['backgroundPic'] ??
                        "https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0",
                    image: suggestionList[index]['displayPicUrl'] ??
                        suggestionList[index]['displayPic'] ??
                        "https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0",
                    is18Plus: suggestionList[index]['isNSFW'] ?? false,
                    type: suggestionList[index]['type'] ?? 'public',
                  );
                  var moderatorsList =
                      suggestionList[index]['moderators'] ?? [];
                  String? username = prefs.getString('username');
                  if (username != null &&
                      moderatorsList != null &&
                      moderatorsList.contains(username)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityProfilePage(
                          community: community,
                          token: token!,
                        ),
                      ),
                    );
                  } else if (username != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityProfilePage(
                          community: community,
                          token: token!,
                        ),
                      ),
                    );
                  }
                } else if (Type == 'Post') {
                  Post post = Post(
                    id: suggestionList[index]['_id'] ?? "",
                    title: suggestionList[index]['title'] ?? "",
                    content: suggestionList[index]['content'] ?? "",
                    communityName: suggestionList[index]['communityId'] ?? "",
                    communityId: suggestionList[index]['communityId'] ?? "",
                    username: suggestionList[index]['username'] ?? "",
                    upVotes: suggestionList[index]['upvotes'] ?? 0,
                    downVotes: suggestionList[index]['downvotes'] ?? 0,
                    comments: suggestionList[index]['numberOfComments'] ?? 0,
                    isNSFW: suggestionList[index]['nsfw'] ?? false,
                    isSpoiler: suggestionList[index]['isSpoiler'] ?? false,
                    imagePath: suggestionList[index]['media'] != null
                        ? (suggestionList[index]['media'] is List &&
                                (suggestionList[index]['media'] as List)
                                    .isNotEmpty
                            ? Uri.encodeFull(extractUrl(
                                (suggestionList[index]['media'] as List)
                                    .first
                                    .toString()))
                            : Uri.encodeFull(extractUrl(
                                suggestionList[index]['media'].toString())))
                        : null,
                    postCategory: "general",
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: const Text('Post Details'),
                        ),
                        body: PostCard(
                          post: post,
                          onHide: () {},
                        ),
                      ),
                    ),
                  );
                } else if (Type == 'User') {
                  User user = User(
                    username: suggestionList[index]['username'],
                    token: token,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        user: user,
                      ),
                    ),
                  );
                }
              },
              leading: const Icon(Icons.history),
              title: RichText(
                text: TextSpan(
                  text: suggestionList[index]['name'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Text(
                suggestionList[index]['Type'] ?? 'Default value',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            itemCount: suggestionList.length,
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
