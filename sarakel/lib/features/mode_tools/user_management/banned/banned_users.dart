// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/user_management/banned/add_banned_users_controller.dart';
import 'package:sarakel/features/mode_tools/user_management/banned/add_banned_users_page.dart';
import 'package:sarakel/features/mode_tools/user_management/banned/banned_users_service.dart';
import 'package:sarakel/features/mode_tools/user_management/banned/search_banned_users_page.dart';
import 'package:sarakel/models/user.dart';
import 'package:sarakel/user_profile/user_profile.dart';

class BannedUsersPage extends StatefulWidget {
  final String token; // Token to be passed to fetch banned
  final String communityName; // Community name

  const BannedUsersPage({
    super.key,
    required this.token,
    required this.communityName,
  });
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
                leading: const Icon(Icons.person),
                title: const Text('View Profile'),
                onTap: () {
                  // Navigate to the user profile page of the banned
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        user: User(
                            username: bannedName,
                            token: widget
                                .token), // Pass the banned's username and token here
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle),
                title: const Text('Unban'),
                onTap: () {
                  // Implement remove banned logic
                  unBanUser(widget.token, bannedName, widget.communityName)
                      .then((unBannedUser) {
                    if (unBannedUser) {
                      // Unbanned user successfully
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Unbanned user successfully')),
                      );
                    } else {
                      // Unbanned usser failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to unban the user')),
                      );
                    }
                  });
                  Navigator.pop(context);
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
          'Banned users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
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
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BanUserPage(
                    token: widget.token,
                    communityName: widget.communityName,
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
          allBanned.isNotEmpty
              ? ListView.builder(
                  itemCount: allBanned.length,
                  itemBuilder: (context, index) {
                    final bannedName = allBanned[index];
                    return ListTile(
                      leading: const Icon(Icons.person), // Icon for banned
                      title: Text(bannedName), // banned name
                      onTap: () {
                        //navigate to the banned's profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(
                              user: User(
                                  username: bannedName,
                                  token: widget
                                      .token), // Pass the banned's username and token here
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
                      leading: const Icon(Icons.person), // Icon for banned
                      title: Text(bannedName), // banned name
                      onTap: () {
                        //navigate to the banned's profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(
                              user: User(
                                  username:
                                      bannedName), // Pass the banned's username and token here
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          _showActionsModal(context, bannedName);
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
