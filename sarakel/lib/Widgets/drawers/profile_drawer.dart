import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarakel/user_profile/user_profile.dart';
import 'package:sarakel/Widgets/settings/settings_controller.dart';
import 'package:sarakel/Widgets/settings/settings_page.dart';
import 'package:sarakel/features/create_circle/create_circle.dart';
import 'package:sarakel/features/saved/saved.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';

///consumer widget to nosume user data
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
                accountEmail: Text('user!.email!'),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CommunityForm(token: user!.token!)));
                },
              ),
              ListTile(
                leading: Icon(Icons.save),
                title: Text('Saved'),
                onTap: () {
                  // Handle Saved tap
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return SavedScreen();
                  }));
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsPage(
                              token: user!.token!,
                              settings: Settings(token: user!.token!))));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
