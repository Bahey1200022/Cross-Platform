import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/widgets/post_card.dart';
import 'package:sarakel/Widgets/profiles/communityprofile_page.dart';
import 'package:sarakel/loadposts.dart';
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
                    image: suggestionList[index]['displayPicUrl'],
                    backimage: suggestionList[index]['backgroundPicUrl'],
                    is18Plus: suggestionList[index]['isNSFW'] ?? false,
                    type: suggestionList[index]['type'] ?? 'public',
                  );
                  var moderatorsList = suggestionList[index]['moderators'];
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
                    id: suggestionList[index]['_id'],
                    title: suggestionList[index]['title'],
                    content: suggestionList[index]['content'],
                    communityName: suggestionList[index]['communityId'],
                    communityId: suggestionList[index]['communityId'],
                    username: suggestionList[index]['username'],
                    upVotes: suggestionList[index]['upvotes'],
                    downVotes: suggestionList[index]['downvotes'],
                    comments: 0,
                    isNSFW: true,
                    isSpoiler: suggestionList[index]['isSpoiler'],
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
