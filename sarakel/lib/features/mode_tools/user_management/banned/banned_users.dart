import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/user_management/banned/banned_users_service.dart';
import 'package:sarakel/features/mode_tools/user_management/banned/search_banned_users_page.dart';
import 'package:sarakel/models/user.dart';
import 'package:sarakel/user_profile/user_profile.dart';

class BannedUsersPage extends StatefulWidget {
  final String token; // Token to be passed to fetch banned
  final String communityName; // Community name

  const BannedUsersPage({
    Key? key,
    required this.token,
    required this.communityName,
  }) : super(key: key);
  @override
  _BannedUsersPageState createState() => _BannedUsersPageState();
}

class _BannedUsersPageState extends State<BannedUsersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> allBanned = []; // List to store all banned

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchBanned(widget.token, widget.communityName);
  }

  Future<void> fetchBanned(String token, String communityName) async {
    try {
      final banned =
          await BannedUsersService.getBannedUsers(token, communityName);
      setState(() {
        allBanned = banned;
      });
    } catch (error) {
      print(error);
      // Handle error
    }
  }

  void _showActionsModal(BuildContext context, String bannedName) {
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
                            username: bannedName,
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
          'Banned users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BannedSearchPage(
                    token: widget.token,
                    communityName: widget.communityName,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {},
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
          allBanned.isNotEmpty
              ? ListView.builder(
                  itemCount: allBanned.length,
                  itemBuilder: (context, index) {
                    final bannedName = allBanned[index];
                    return ListTile(
                      leading: Icon(Icons.person), // Icon for moderator
                      title: Text(bannedName), // Moderator name
                      onTap: () {
                        //navigate to the moderator's profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(
                              user: User(
                                  username: bannedName,
                                  token: widget
                                      .token), // Pass the moderator's username and token here
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No banned users',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20, // Increased font size
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Users banned from the subsarakel will appear here',
                        style: TextStyle(fontSize: 18), // Increased font size
                      ),
                    ],
                  ),
                ),
          // Content for "Editable" tab
          allBanned.isNotEmpty
              ? ListView.builder(
                  itemCount: allBanned.length,
                  itemBuilder: (context, index) {
                    final bannedName = allBanned[index];
                    return ListTile(
                      leading: Icon(Icons.person), // Icon for moderator
                      title: Text(bannedName), // Moderator name
                      onTap: () {
                        //navigate to the moderator's profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(
                              user: User(
                                  username:
                                      bannedName), // Pass the moderator's username and token here
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          _showActionsModal(context, bannedName);
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No banned users',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20, // Increased font size
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Users banned from the subsarakel will appear here',
                        style: TextStyle(fontSize: 18), // Increased font size
                      ),
                    ],
                  ),
                ), // If no banned users, return an empty center widget
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
