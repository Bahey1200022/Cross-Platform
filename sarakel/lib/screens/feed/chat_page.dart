import 'package:flutter/material.dart';
import '../../drawers/community_list.dart';
import '../../drawers/profile_drawer.dart';
import '../../models/post.dart';
import 'widgets/app_bar.dart';
import 'widgets/bottom_bar.dart';

class ChatSection extends StatefulWidget {
  @override
  State<ChatSection> createState() => _ChatSection();
}

class _ChatSection extends State<ChatSection> {
  int _selectedIndex = 3;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey(); // Create a GlobalKey

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey, // Provide the GlobalKey to the Scaffold

        appBar: CustomAppBar(
          title: 'chat',
          scaffoldKey: _scaffoldKey, // Pass the GlobalKey to the CustomAppBar
        ),
        drawer: communityDrawer(),
        endDrawer: ProfileDrawer(
          // Add end drawer
          userName: 'Ziad Zaza', // Replace with user name
          userImageUrl:
              'assets/avatar_logo.jpeg', // Replace with user image URL
          userID: 'user.email',
        ),
        body: Center(
          child: Text('Chat Page is under construction'),
        ),
        bottomNavigationBar:
            CustomBottomNavigationBar(currentIndex: _selectedIndex));
  }
}
