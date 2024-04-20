import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/explore_communities/join_button.dart';
import 'package:sarakel/Widgets/explore_communities/join_button_controller.dart';
import 'package:sarakel/Widgets/explore_communities/leave_community_controller.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
            backgroundColor: const Color.fromARGB(255, 43, 126, 243),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  showSearch(context: context, delegate: sarakelSearch());
                },
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo_2d.png'),
                  fit: BoxFit.fill,
                ),
              ),
            )),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/avatar_logo.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'c/${widget.community.name}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (widget.showJoinButton) ...[
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
                    child: const Text(
                      'Mod Tools',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text(
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
