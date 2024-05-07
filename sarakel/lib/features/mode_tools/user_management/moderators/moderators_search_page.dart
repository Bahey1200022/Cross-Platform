// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/user_management/moderators/moderators_service.dart';
import 'package:sarakel/user_profile/user_profile.dart';
import 'package:sarakel/models/user.dart';

/// This class represents the search page where users can search for moderators by typing their usernames.
/// It allows users to input a username in a TextField and displays the matching moderator if found.
class ModeratorSearchPage extends StatefulWidget {
  final String token;
  final String communityName;

  const ModeratorSearchPage({super.key, 
    required this.token,
    required this.communityName,
  });

  @override
  _ModeratorSearchPageState createState() => _ModeratorSearchPageState();
}

/// This stateful widget represents the state for the ModeratorSearchPage.
/// It manages the UI state and handles fetching and displaying moderators based on user input.
class _ModeratorSearchPageState extends State<ModeratorSearchPage> {
  final TextEditingController _controller = TextEditingController();
  String? moderatorName;

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
                    onChanged: fetchModerator,
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
          if (moderatorName != null)
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                moderatorName!,
                style: const TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(
                      user: User(
                        username: moderatorName!,
                        token: widget.token,
                      ),
                    ),
                  ),
                );
              },
            ),
          Expanded(
            child: Center(
              child: moderatorName == null
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

  /// Fetches the moderator based on the provided username.
  /// If the username matches a moderator, it updates the UI to display the moderator.
  /// If no match is found, it resets the UI.
  void fetchModerator(String value) {
    if (value.isEmpty) {
      setState(() {
        moderatorName = null;
      });
      return;
    }

    ModerationService.getModerators(widget.token, widget.communityName)
        .then((moderators) {
      if (moderators.contains(value)) {
        setState(() {
          moderatorName = value;
        });
      } else {
        setState(() {
          moderatorName = null;
        });
      }
    }).catchError((error) {
      print('Error fetching moderators: $error');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
