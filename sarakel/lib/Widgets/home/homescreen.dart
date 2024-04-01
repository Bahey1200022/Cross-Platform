import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarakel/Widgets/drawers/community_list.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:sarakel/models/user.dart';
import 'package:sarakel/providers/user_provider.dart';
import '../drawers/profile_drawer.dart';
import '../../models/post.dart';
import 'controllers/home_screen_controller.dart';
import 'widgets/post_card.dart';
import 'widgets/bottom_bar.dart';

class SarakelHomeScreen extends StatefulWidget {
  HomescreenController homescreenController;

  SarakelHomeScreen({required this.homescreenController, super.key});

  @override
  State<SarakelHomeScreen> createState() => _SarakelHomeScreenState();
}

class _SarakelHomeScreenState extends State<SarakelHomeScreen> {
  final int _selectedIndex = 0;
  String _selectedPage = 'Home';
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;
    widget.homescreenController.fetchAndSetCommunities(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: DropdownButton<String>(
          value: _selectedPage,
          items: const [
            DropdownMenuItem(
              value: 'Home',
              child: Text('Home',
                  style: TextStyle(
                      color: Colors
                          .black)), // Ensures contrast against white AppBar
            ),
            DropdownMenuItem(
              value: 'Popular',
              child: Text('Popular',
                  style: TextStyle(
                      color: Colors
                          .black)), // Ensures contrast against white AppBar
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedPage = value!;
            });
          },
          underline: Container(), // Removes the underline
          style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight
                  .bold), // Default style for text, ensures contrast before dropdown is clicked
          iconEnabledColor:
              Colors.black, // Ensures the icon is visible against white AppBar
          dropdownColor: Colors
              .deepOrange, // Background color of the dropdown menu, ensure text color contrasts with this when active
        ),
        leading: IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: sarakelSearch());
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
      drawer: CommunityDrawer(),
      endDrawer: ProfileDrawer(
        // Add end drawer
        user: user,
      ),
      body: FutureBuilder<List<Post>>(
        future: widget.homescreenController.loadPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading posts"));
          } else if (snapshot.hasData) {
            final postsToShow =
                _selectedPage == 'Home' ? snapshot.data! : snapshot.data!;
            return ListView.builder(
              itemCount: postsToShow.length,
              itemBuilder: (context, index) =>
                  PostCard(post: postsToShow[index]), // Corrected line
            );
          } else {
            return const Center(child: Text('No posts found'));
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
      ),
    );
  }
}
