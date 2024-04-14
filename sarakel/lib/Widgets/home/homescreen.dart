import 'dart:core';

import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/drawers/community_drawer/community_list.dart';
import 'package:sarakel/Widgets/drawers/profile_drawer.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import '../../models/post.dart';
import 'controllers/home_screen_controller.dart';
import 'widgets/post_card.dart';
import 'widgets/bottom_bar.dart';

class SarakelHomeScreen extends StatefulWidget {
  final HomescreenController homescreenController;

  const SarakelHomeScreen({required this.homescreenController, super.key});

  @override
  State<SarakelHomeScreen> createState() => _SarakelHomeScreenState();
}

class _SarakelHomeScreenState extends State<SarakelHomeScreen> {
  final int _selectedIndex = 0;
  String _selectedPage = 'Home';
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<Post>? postsToShow;
  Set<String> hiddenPostIds = Set();
  @override
  void initState() {
    super.initState();
    widget.homescreenController.loadPosts().then((posts) {
      print(posts);
      if (mounted) {
        setState(() => postsToShow = posts);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //User? user = Provider.of<UserProvider>(context).user;

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
      drawer: CommunityDrawer(token: widget.homescreenController.token),
      endDrawer: ProfileDrawer(
        // Add end drawer ////to be fixed
        user: widget.homescreenController.getUser(),
      ),
      body: postsToShow == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: postsToShow!.length,
              itemBuilder: (context, index) {
                final post = postsToShow![index];
                if (hiddenPostIds.contains(post.id)) {
                  // If post is hidden, show an Undo button
                  return Card(
                    child: ListTile(
                      title: Text('Post hidden'),
                      trailing: IconButton(
                        icon: Icon(Icons.undo),
                        onPressed: () {
                          setState(() {
                            hiddenPostIds.remove(post.id); // Unhide the post
                          });
                        },
                      ),
                    ),
                  );
                } else {
                  // Show the post
                  return PostCard(
                    post: post,
                    onHide: () {
                      setState(() {
                        hiddenPostIds.add(post.id); // Hide the post
                      });
                    },
                  );
                }
              },
            ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        token: widget.homescreenController.token,
      ),
    );
  }
}
