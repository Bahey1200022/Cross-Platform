import 'package:flutter/material.dart';

import 'package:sarakel/models/user.dart';
import 'package:sarakel/user_profile/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sarakel/Widgets/settings/search_blocked_accounts.dart';

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
                query = suggestionList[index];
                print(query);
                // Navigate to the desired page

                User user = User(
                  username: suggestionList[index],
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
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: suggestionList[index],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // unblockUser(suggestionList[index]);

                  TextButton(
                    onPressed: () async {
                      final isBlocked =
                          await isUserBlocked(suggestionList[index]);
                      if (isBlocked) {
                        // User is already blocked, unblock the user
                        unblockUser(suggestionList[index]);
                      } else {
                        // User is not blocked, block the user
                        blockUser(suggestionList[index]);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isBlocked
                                ? 'You unblocked ${suggestionList[index]}'
                                : 'You blocked ${suggestionList[index]}',
                          ),
                        ),
                      );

                      query = ''; // Clear the search bar
                      // query = ''; // Clear the search bar
                    },
                    child: FutureBuilder<bool>(
                      future: isUserBlocked(suggestionList[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                            'Block', // Show "Block" by default if there's an error
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          );
                        } else if (snapshot.data!) {
                          return Text(
                            'Unblock', // Show "Unblock" if user is already blocked
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          );
                        } else {
                          return Text(
                            'Block', // Show "Block" if user is not blocked
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
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

Future<bool> isUserBlocked(String username) async {
  final blockedUsers = await getBlockedUsers();
  return blockedUsers.contains(username);
}
