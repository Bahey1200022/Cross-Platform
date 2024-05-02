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
    super.key,
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
                accountEmail: const Text('Sarakel developer'),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar_logo.jpeg'),
                ),
                decoration: const BoxDecoration(
                  color:
                      Colors.deepOrange, // Set the background color to orange
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return UserProfile(user: user);
                  }));
                },
              ),
              ListTile(
                leading: const Icon(Icons.group_outlined),
                title: const Text('Create a community'),
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
                    return const SavedScreen();
                  }));
                },
              ),
              ListTile(
                leading: const Icon(Icons.history_outlined),
                title: const Text('History'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => History(token: user!.token!)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
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
