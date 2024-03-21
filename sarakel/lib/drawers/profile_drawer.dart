import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarakel/screens/user/user_profile.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class ProfileDrawer extends StatelessWidget {
  final User? user;

  const ProfileDrawer({
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder:
          (BuildContext context, UserProvider userProvider, Widget? child) {
        // User? user = userProvider.user;

        return Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user!.username!),
                accountEmail: Text(user!.email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar_logo.jpeg'),
                ),
                decoration: BoxDecoration(
                  color:
                      Colors.deepOrange, // Set the background color to orange
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('My Profile'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return UserProfile(user: user);
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.group),
                title: Text('Create a circle'),
                onTap: () {
                  Navigator.pushNamed(context, '/create_circle');
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
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
