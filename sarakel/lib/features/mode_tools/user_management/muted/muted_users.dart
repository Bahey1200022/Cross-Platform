// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/user_management/muted/muted_users_service.dart';
import 'package:sarakel/features/mode_tools/user_management/muted/search_muted_users_page.dart';
import 'package:sarakel/models/user.dart';
import 'package:sarakel/user_profile/user_profile.dart';

class MutedUsersPage extends StatefulWidget {
  final String token; // Token to be passed to fetch muted
  final String communityName; // Community name

  const MutedUsersPage({
    super.key,
    required this.token,
    required this.communityName,
  });
  @override
  _MutedUsersPageState createState() => _MutedUsersPageState();
}

class _MutedUsersPageState extends State<MutedUsersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> allMuted = []; // List to store all muted

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchMuted(widget.token, widget.communityName);
  }

  Future<void> fetchMuted(String token, String communityName) async {
    try {
      final muted = await MutedUsersService.getMutedUsers(token, communityName);
      setState(() {
        allMuted = muted;
      });
    } catch (error) {
      print(error);
      // Handle error
    }
  }

  void _showActionsModal(BuildContext context, String mutedName) {
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
                  // Navigate to the user profile page of the muted
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        user: User(
                            username: mutedName,
                            token: widget
                                .token), // Pass the muted's username and token here
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle),
                title: const Text('Remove'),
                onTap: () {
                  // Implement remove muted logic
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
          'Muted users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MutedSearchPage(
                    token: widget.token,
                    communityName: widget.communityName,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {},
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
          allMuted.isNotEmpty
              ? ListView.builder(
                  itemCount: allMuted.length,
                  itemBuilder: (context, index) {
                    final mutedName = allMuted[index];
                    return ListTile(
                      leading: const Icon(Icons.person), // Icon for muted
                      title: Text(mutedName), // muted name
                      onTap: () {
                        //navigate to the muted's profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(
                              user: User(
                                  username: mutedName,
                                  token: widget
                                      .token), // Pass the muted's username and token here
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No muted users',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20, // Increased font size
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Users muted from the subsarakel will appear here',
                        style: TextStyle(fontSize: 18), // Increased font size
                      ),
                    ],
                  ),
                ),
          // Content for "Editable" tab
          allMuted.isNotEmpty
              ? ListView.builder(
                  itemCount: allMuted.length,
                  itemBuilder: (context, index) {
                    final mutedName = allMuted[index];
                    return ListTile(
                      leading: const Icon(Icons.person), // Icon for muted
                      title: Text(mutedName), // muted name
                      onTap: () {
                        //navigate to the muted's profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(
                              user: User(
                                  username:
                                      mutedName), // Pass the muted's username and token here
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          _showActionsModal(context, mutedName);
                        },
                      ),
                    );
                  },
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No muted users',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20, // Increased font size
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Users muted from the subsarakel will appear here',
                        style: TextStyle(fontSize: 18), // Increased font size
                      ),
                    ],
                  ),
                ), // If no muted users, return an empty center widget
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
