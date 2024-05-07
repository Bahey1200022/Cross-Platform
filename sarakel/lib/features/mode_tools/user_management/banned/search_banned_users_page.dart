// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/user_management/banned/banned_users_service.dart';
import 'package:sarakel/user_profile/user_profile.dart';
import 'package:sarakel/models/user.dart';

/// This class represents the search page where users can search for banned  by typing their usernames.
/// It allows users to input a username in a TextField and displays the matching banned  if found.
class BannedSearchPage extends StatefulWidget {
  final String token;
  final String communityName;

  const BannedSearchPage({super.key, 
    required this.token,
    required this.communityName,
  });

  @override
  _BannedSearchPageState createState() => _BannedSearchPageState();
}

/// This stateful widget represents the state for the banned earchPage.
/// It manages the UI state and handles fetching and displaying banned  based on user input.
class _BannedSearchPageState extends State<BannedSearchPage> {
  final TextEditingController _controller = TextEditingController();
  String? bannedName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: _controller,
                    onChanged: fetchBanned,
                    decoration: InputDecoration(
                      hintText: 'Search by username',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color.fromARGB(255, 124, 119, 119),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (bannedName != null)
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                bannedName!,
                style: const TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(
                      user: User(
                        username: bannedName!,
                        token: widget.token,
                      ),
                    ),
                  ),
                );
              },
            ),
          Expanded(
            child: Center(
              child: bannedName == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Search by username',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Only exact matches will be found',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  /// Fetches the banned  based on the provided username.
  /// If the username matches a banned , it updates the UI to display the banned .
  /// If no match is found, it resets the UI.
  void fetchBanned(String value) {
    if (value.isEmpty) {
      setState(() {
        bannedName = null;
      });
      return;
    }

    BannedUsersService.getBannedUsers(widget.token, widget.communityName)
        .then((banned) {
      if (banned.contains(value)) {
        setState(() {
          bannedName = value;
        });
      } else {
        setState(() {
          bannedName = null;
        });
      }
    }).catchError((error) {
      print('Error fetching banned : $error');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
