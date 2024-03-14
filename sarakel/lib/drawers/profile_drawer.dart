import 'package:flutter/material.dart';

class ProfileDrawer extends StatelessWidget {
  final String userName;
  final String userImageUrl;
  final String userID;

  const ProfileDrawer({
    required this.userName,
    required this.userImageUrl,
    required this.userID,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userID),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(userImageUrl),
            ),
            decoration: BoxDecoration(
              color: Colors.deepOrange, // Set the background color to orange
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('My Profile'),
            onTap: () {
              // Handle My Profile tap
              Navigator.pushNamed(context, '/user_profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Create a Community'),
            onTap: () {
              // Handle Create a Community tap
            },
          ),
          ListTile(
            leading: Icon(Icons.save),
            title: Text('Saved'),
            onTap: () {
              // Handle Saved tap
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {
              // Handle History tap
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Handle Settings tap
            },
          ),
        ],
      ),
    );
  }
}
