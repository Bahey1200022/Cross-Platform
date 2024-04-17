import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarakel/features/history/history.dart';
import 'package:sarakel/user_profile/user_profile.dart';
import 'package:sarakel/Widgets/settings/settings_controller.dart';
import 'package:sarakel/Widgets/settings/settings_page.dart';
import 'package:sarakel/features/create_community/create_community.dart';
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
        String username = user!.username!; //Hafez

        return Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('u/$username'),
                accountEmail: Text('Sarakel developer'),
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
                leading: Icon(Icons.account_circle_outlined),
                title: Text('Profile'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return UserProfile(user: user);
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.group_outlined),
                title: Text('Create a community'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CommunityForm(token: user!.token!)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.save_outlined),
                title: const Text('Saved'),
                onTap: () {
                  // Handle Saved tap
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return SavedScreen();
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.history_outlined),
                title: Text('History'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => History(token: user!.token!)));
                },
              ),
              ListTile(
                leading: Icon(Icons.settings_outlined),
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
