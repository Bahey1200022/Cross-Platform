import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/user_management/banned/banned_users_service.dart';
import 'package:sarakel/user_profile/user_profile.dart';
import 'package:sarakel/models/user.dart';

/// This class represents the search page where users can search for moderators by typing their usernames.
/// It allows users to input a username in a TextField and displays the matching moderator if found.
class BannedSearchPage extends StatefulWidget {
  final String token;
  final String communityName;

  BannedSearchPage({
    required this.token,
    required this.communityName,
  });

  @override
  _BannedSearchPageState createState() => _BannedSearchPageState();
}

/// This stateful widget represents the state for the ModeratorSearchPage.
/// It manages the UI state and handles fetching and displaying moderators based on user input.
class _BannedSearchPageState extends State<BannedSearchPage> {
  final TextEditingController _controller = TextEditingController();
  String? bannedName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: _controller,
                    onChanged: fetchBanned,
                    decoration: InputDecoration(
                      hintText: 'Search by username',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
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
              leading: Icon(Icons.person),
              title: Text(
                bannedName!,
                style: TextStyle(fontSize: 18),
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
                  ? Column(
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
                  : SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  /// Fetches the moderator based on the provided username.
  /// If the username matches a moderator, it updates the UI to display the moderator.
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
      print('Error fetching moderators: $error');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
