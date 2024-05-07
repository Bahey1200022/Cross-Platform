// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/user_management/moderators/add_moderators_page.dart';
import 'package:sarakel/features/mode_tools/user_management/moderators/moderators_search_page.dart';
import 'package:sarakel/features/mode_tools/user_management/moderators/moderators_service.dart';
import 'package:sarakel/user_profile/user_profile.dart'; // Import the UserProfile page
import 'package:sarakel/models/user.dart'; // Import the User model

class ModeratorsPage extends StatefulWidget {
  final String token; // Token to be passed to fetch moderators
  final String communityName; // Community name

  const ModeratorsPage({
    super.key,
    required this.token,
    required this.communityName,
  });

  @override
  _ModeratorsPageState createState() => _ModeratorsPageState();
}

class _ModeratorsPageState extends State<ModeratorsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> allModerators = []; // List to store all moderators

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchModerators(widget.token, widget.communityName);
  }

  Future<void> fetchModerators(String token, String communityName) async {
    try {
      final moderators =
          await ModerationService.getModerators(token, communityName);
      setState(() {
        allModerators = moderators;
      });
    } catch (error) {
      print(error);
      // Handle error
    }
  }

  void _showActionsModal(BuildContext context, String moderatorName) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('View Profile'),
                onTap: () {
                  // Navigate to the user profile page of the moderator
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        user: User(
                            username: moderatorName,
                            token: widget
                                .token), // Pass the moderator's username and token here
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle),
                title: const Text('Remove'),
                onTap: () {
                  // Implement remove moderator logic
                },
              ),
              ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BFA5),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Moderators',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModeratorSearchPage(
                    token: widget.token,
                    communityName: widget.communityName,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddModeratorPage(
                    communityName: widget.communityName,
                    token: widget.token,
                  ),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'), // Tab for "All"
            Tab(text: 'Editable'), // Tab for "Editable"
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Content for "All" tab
          ListView.builder(
            itemCount: allModerators.length,
            itemBuilder: (context, index) {
              final moderatorName = allModerators[index];
              return ListTile(
                leading: const Icon(Icons.person), // Icon for moderator
                title: Text(moderatorName), // Moderator name
                onTap: () {
                  //navigate to the moderator's profile
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        user: User(
                            username: moderatorName,
                            token: widget
                                .token), // Pass the moderator's username and token here
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // Content for "Editable" tab
          ListView.builder(
            itemCount: allModerators.length,
            itemBuilder: (context, index) {
              final moderatorName = allModerators[index];
              return ListTile(
                leading: const Icon(Icons.person), // Icon for moderator
                title: Text(moderatorName), // Moderator name
                onTap: () {
                  //navigate to the moderator's profile
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        user: User(
                            username:
                                moderatorName), // Pass the moderator's username and token here
                      ),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    _showActionsModal(context, moderatorName);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
