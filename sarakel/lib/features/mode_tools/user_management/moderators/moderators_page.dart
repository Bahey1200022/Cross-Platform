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
    Key? key,
    required this.token,
    required this.communityName,
  }) : super(key: key);

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
                leading: Icon(Icons.person),
                title: Text('View Profile'),
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
                leading: Icon(Icons.remove_circle),
                title: Text('Remove'),
                onTap: () {
                  // Implement remove moderator logic
                },
              ),
              ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF00BFA5),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Center(
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Moderators',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModeratorSearchPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddModeratorPage(),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
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
                leading: Icon(Icons.person), // Icon for moderator
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
                leading: Icon(Icons.person), // Icon for moderator
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
                  icon: Icon(Icons.more_vert),
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
