// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:core';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/drawers/community_drawer/community_list.dart';
import 'package:sarakel/Widgets/drawers/profile_drawer.dart';
import 'package:sarakel/Widgets/home/hot.dart';
import 'package:sarakel/Widgets/home/random.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/Widgets/home/widgets/postisLiked.dart';
import 'package:sarakel/constants.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/post.dart';
import 'controllers/home_screen_controller.dart';
import 'widgets/post_card.dart';
import 'widgets/bottom_bar.dart';
import 'popular.dart';

///homescreen displaying postcards
class SarakelHomeScreen extends StatefulWidget {
  final HomescreenController homescreenController;

  const SarakelHomeScreen({required this.homescreenController, super.key});

  @override
  State<SarakelHomeScreen> createState() => _SarakelHomeScreenState();
}

class _SarakelHomeScreenState extends State<SarakelHomeScreen> {
  final int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<Post>? postsToShow;
  Set<String> hiddenPostIds = {};

  @override
  void initState() {
    super.initState();
    getmarked();

    widget.homescreenController.loadNewPosts().then((posts) {
      setState(() => postsToShow = posts);
    });
  }

  Future<void> unhidePost(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var response = await http.post(
        Uri.parse('$BASE_URL/api/unhide'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',

          // Remove the token if it's not required by your backend
        },
        body: jsonEncode({
          'type': 'post',
          'entityId': id,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post Successfully Unhidden!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to unhide post: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error unhiding post: $e')),
      );
    }
  }

  Future<void> hidePost(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var response = await http.post(
        Uri.parse('$BASE_URL/api/hide'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Remove the token if it's not required by your backend
        },
        body: jsonEncode({
          'type': 'post',
          'entityId': id,
        }),
      );
      print(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post Successfully Hidden!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to hide post: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error hiding post: $e')),
      );
    }
  }

  ///builds the homescreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(0, kToolbarHeight, 0, 0),
              items: <PopupMenuEntry<String>>[
                ///menu items for home screen
                const PopupMenuItem<String>(
                  value: 'home',
                  child: Row(
                    children: [
                      Icon(Icons.home, color: Colors.black), // Set icon color
                      SizedBox(width: 8),
                      Text('Home',
                          style:
                              TextStyle(color: Colors.black)), // Set text color
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'popular',
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Popular', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'hot',
                  child: Row(
                    children: [
                      Icon(Icons.whatshot, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Hot', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'random',
                  child: Row(
                    children: [
                      Icon(Icons.shuffle, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Random', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ).then((value) {
              // Handle menu item selection if needed
              if (value != null) {
                switch (value) {
                  case 'home':
                    // Navigate to Home page
                    break;
                  case 'popular':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SarakelPopularScreen(
                            homescreenController: widget.homescreenController),
                      ),
                    );
                    break;
                  case 'hot':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SarakelHotScreen(
                            homescreenController: widget.homescreenController),
                      ),
                    );
                    break;
                  case 'random':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SarakelRandomScreen(
                            homescreenController: widget.homescreenController),
                      ),
                    );
                    break;
                  default:
                    break;
                }
              }
            });
          },
          child: const Row(
            children: [
              Text(
                "sarakel",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: sarakelSearch());
            },
          ),
          IconButton(
            icon: Stack(
              children: [
                Image.asset('assets/avatar_logo.jpeg'),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
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
          ? Center(child: Image.asset('assets/logo_2d.png', width: 30))
          : CustomMaterialIndicator(
              indicatorBuilder: (context, controller) {
                return Image.asset('assets/logo_2d.png', width: 30);
              },
              onRefresh: () async {
                await widget.homescreenController.loadPosts().then((posts) {
                  setState(() => postsToShow = posts);
                });
              },
              child: ListView.builder(
                itemCount: postsToShow!.length,
                itemBuilder: (context, index) {
                  final post = postsToShow![index];
                  if (hiddenPostIds.contains(post.id)) {
                    // If post is hidden, show an Undo button
                    return Card(
                      child: ListTile(
                        title: const Text('Post hidden'),
                        trailing: IconButton(
                          icon: const Icon(Icons.undo),
                          onPressed: () {
                            unhidePost(post.id);
                            setState(() {
                              hiddenPostIds.remove(post.id);
                              // Unhide the post
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
                        hidePost(post.id);
                        setState(() {
                          hiddenPostIds.add(
                              post.id); // Adjust based on your API response

                          // Hide the post
                        });
                      },
                    );
                  }
                },
              ),
            ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        token: widget.homescreenController.token,
      ),
    );
  }
}
