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
import 'package:sarakel/Widgets/settings/search_muted_community.dart';

///Search delegate class for the search bar
///searching for users posts and communities
class BlockedSearch extends SearchDelegate {
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
      future: fetchBlockedSuggestions(query), // Pass the query to the API call
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final suggestionList = snapshot.data!;
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString('token');
                query = suggestionList[index]['name'];
                print(query);
                // Navigate to the desired page

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
