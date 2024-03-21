import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarakel/drawers/community_list.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:sarakel/models/user.dart';
import 'package:sarakel/providers/user_provider.dart';
import '../../drawers/profile_drawer.dart';
import '../../models/post.dart';
import '../../controllers/home_screen_controller.dart';
import '../feed/widgets/post_card.dart';
import '../feed/widgets/bottom_bar.dart';

class SarakelHomeScreen extends StatefulWidget {
  @override
  State<SarakelHomeScreen> createState() => _SarakelHomeScreenState();
}

class _SarakelHomeScreenState extends State<SarakelHomeScreen> {
  final int _selectedIndex = 0;
  String _selectedPage = 'Home';
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final List<Post> _homePosts = [
    Post(
        communityName: 'flutter',
        duration: '4h',
        upVotes: '120',
        comments: '30',
        title: 'hi',
        shares: '15',
        content: 'Did you check out the brand new feature!!!!',
        communityId: '1'),
    Post(
        communityName: 'dart',
        duration: '23h',
        upVotes: '75',
        title: 'hi',
        comments: '12',
        shares: '5',
        content:
            'Dart 2.12 brings sound null safety, improving your codes reliability and performance.',
        communityId: '2'),
    // Add more posts here
  ];
  final List<Post> _popularPosts = [
    Post(
        communityName: 'android',
        duration: '2d',
        upVotes: '200',
        comments: '50',
        title: 'hi',
        shares: '25',
        content: 'Exploring the new Android 12 features.',
        communityId: '3'),
    Post(
        communityName: 'ios',
        duration: '1d',
        upVotes: '150',
        comments: '40',
        title: 'hi',
        shares: '20',
        content: 'What\'s new in iOS 15? Let\'s dive in.',
        communityId: '4'),
    // Add more "Popular" posts here
  ];

  @override
  Widget build(BuildContext context) {
    HomescreenController homescreenController = HomescreenController();
    User? user = Provider.of<UserProvider>(context).user;
    homescreenController.fetchAndSetCommunities(context);

    final List<Post> _postsToShow =
        _selectedPage == 'Home' ? _homePosts : _popularPosts;
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
        future: homescreenController.loadPosts(),
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
                  buildPostCard(postsToShow[index]),
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
