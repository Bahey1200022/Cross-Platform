// ignore_for_file: library_private_types_in_public_api, must_be_immutable, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/settings/settings_controller.dart';
import 'package:sarakel/Widgets/settings/settings_page.dart';
import 'package:sarakel/features/history/history.dart';
import 'package:sarakel/user_profile/get_userpic.dart';
import 'package:sarakel/user_profile/user_profile.dart';
import 'package:sarakel/features/create_community/create_community.dart';
import 'package:sarakel/features/saved/saved.dart';
import '../../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sarakel/socket.dart';

class ProfileDrawer extends StatefulWidget {
  final User? user;
  String? photo = '';
  ProfileDrawer({
    super.key,
    this.user,
  });

  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  bool isOnline = true;

  void logout(BuildContext context) async {
    SocketService.instance.socket!.disconnect();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('username');
    Navigator.pushNamed(context, '/welcome');
  }

  void getImage() async {
    print(widget.user!.username!);
    if (widget.user != null && widget.user!.username != null) {
      try {
        String photoUrl = await getPicUrl(widget.user!.username!);
        widget.user?.photoUrl = photoUrl;
        widget.photo = photoUrl;
        print(widget.user?.photoUrl);
      } catch (e) {
        print('Failed to get image: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.black,
              ),
            ],
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(widget.photo!),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const ListTile(
                                title: Text(
                                  'ACCOUNT',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      AssetImage('assets/avatar_logo.jpeg'),
                                ),
                                title: Text(
                                  'u/${widget.user!.username}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check, color: Colors.blue),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      icon: const Icon(Icons.logout),
                                      onPressed: () {
                                        logout(context);
                                      },
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                  child: Text(
                                    'CLOSE',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'u/${widget.user!.username}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down,
                          color: Colors.black),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isOnline = !isOnline;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isOnline ? Colors.green : Colors.grey,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (isOnline)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                              ),
                            Text(
                              isOnline
                                  ? 'Online Status: On'
                                  : 'Online Status: Off',
                              style: TextStyle(
                                fontSize: 12,
                                color: isOnline ? Colors.green : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            tileColor: Colors.white,
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return UserProfile(user: widget.user);
              }));
            },
          ),
          ListTile(
            tileColor: Colors.white,
            leading: const Icon(Icons.group_outlined),
            title: const Text('Create a community'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CommunityForm(token: widget.user!.token!),
                ),
              );
            },
          ),
          ListTile(
            tileColor: Colors.white,
            leading: const Icon(Icons.save_outlined),
            title: const Text('Saved'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return const SavedScreen();
              }));
            },
          ),
          ListTile(
            tileColor: Colors.white,
            leading: const Icon(Icons.history_outlined),
            title: const Text('History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => History(token: widget.user!.token!),
                ),
              );
            },
          ),
          ListTile(
            tileColor: Colors.white,
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    backgroundColor:
                        Colors.white, // Set background color to white
                    appBar: AppBar(
                      title: const Text('Settings'),
                    ),
                    body: SettingsPage(
                      token: widget.user!.token!,
                      settings: Settings(token: widget.user!.token!),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
