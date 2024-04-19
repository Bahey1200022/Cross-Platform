import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/explore_communities/join_button.dart';
import 'package:sarakel/Widgets/explore_communities/join_button_controller.dart';
import 'package:sarakel/Widgets/explore_communities/leave_community_controller.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/features/mode_tools/moderator_tools.dart';

class CommunityProfilePage extends StatefulWidget {
  final Community community;
  final String token;
  final bool showModToolsButton;
  final bool showJoinButton;

  CommunityProfilePage({
    required this.community,
    required this.token,
    this.showModToolsButton = true,
    this.showJoinButton = true,
  });

  @override
  _CommunityProfilePageState createState() => _CommunityProfilePageState();
}

class _CommunityProfilePageState extends State<CommunityProfilePage> {
  bool _isJoined = false;

  @override
  void initState() {
    super.initState();
    checkIfJoined();
  }

  void checkIfJoined() async {
    // Check if the user is already joined to the community
    // Implement your logic here to determine if the user is joined
    // For demonstration, assuming the user is joined if showJoinButton is false
    setState(() {
      _isJoined = !widget.showJoinButton;
    });
  }

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
                      widget.community.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                if (widget.showJoinButton) ...[
                  SizedBox(height: 16),
                  JoinButton(
                    isJoined: _isJoined,
                    onPressed: () async {
                      setState(() {
                        _isJoined = !_isJoined;
                      });
                      if (_isJoined) {
                        await JoinCommunityController.joinCommunity(
                            widget.community.name, widget.token);
                      } else {
                        // Add logic to leave the community
                        await LeaveCommunityController.leaveCommunity(
                            widget.community.name, widget.token);
                      }
                    },
                  ),
                ],
                if (widget.showModToolsButton) ...[
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModeratorTools(
                            token: widget.token,
                          ),
                        ),
                      );

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
