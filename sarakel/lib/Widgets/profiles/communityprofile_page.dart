import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/explore_communities/join_button_controller.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/widgets/explore_communities/join_button.dart'; // Import the JoinButton widget

class CommunityProfilePage extends StatelessWidget {
  final Community community;
  final String token;
  final bool showModToolsButton;
  final bool showJoinButton;

  CommunityProfilePage({
    required this.community,
    required this.token,
    this.showModToolsButton = false,
    this.showJoinButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 43, 126, 243),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/avatar_logo.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      community.name, // Use the community attribute here
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                if (showJoinButton) ...[
                  SizedBox(height: 16),
                  JoinButton(
                    onPressed: () async {
                      // Call the joinCommunity function from the controller
                      await JoinCommunityController.joinCommunity(
                          community.name, token);
                    },
                  ),
                ],
                if (showModToolsButton) ...[
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Add your logic for Mod Tools here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Mod Tools',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: Text(
                'See Community Info',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
