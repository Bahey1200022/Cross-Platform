import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarakel/drawers/community_list.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/models/user.dart';
import 'package:sarakel/providers/user_communities.dart';
import 'package:sarakel/providers/user_provider.dart';
import '../../models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Community>> loadCommunities() async {
  try {
    // Make a GET request to fetch the JSON data from the server
    var response =
        await http.get(Uri.parse('http://localhost:3000/communities'));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Decode the JSON response into a list
      List<dynamic> jsonData = json.decode(response.body);

      // Map the community data to Community objects
      List<Community> fetchedCommunities = jsonData.map((communityData) {
        return Community(
          id: communityData['id'],
          name: communityData['name'],
          description: communityData['description'],
          image: communityData['image'],
        );
      }).toList();

      return fetchedCommunities; // Return the fetched communities list
    } else {
      // Return an empty list if the response status code is not 200
      return [];
    }
  } catch (e) {
    print('Error loading communities: $e');
    // Return an empty list if an error occurs
    return [];
  }
}

Future<void> fetchAndSetCommunities(BuildContext context) async {
  try {
    List<Community> fetchedCommunities = await loadCommunities();
    print(fetchedCommunities);
    Provider.of<UserCommunitiesProvider>(context, listen: false)
        .setCommunity(fetchedCommunities);
  } catch (e) {
    print('Error loading communities: $e');
    // Handle the error as needed
  }
}

class SarakelHomeScreen extends StatefulWidget {
  @override
  State<SarakelHomeScreen> createState() => _SarakelHomeScreenState();
}

class _SarakelHomeScreenState extends State<SarakelHomeScreen> {
  int _selectedIndex = 0;
  String _selectedPage = 'Home';

  final List<Post> _homePosts = [
    Post(
        communityName: 'flutter',
        duration: '4h',
        upVotes: 120,
        comments: 30,
        shares: 15,
        content: 'Did you check out the brand new feature!!!!',
        communityId: '1'),
    Post(
        communityName: 'dart',
        duration: '23h',
        upVotes: 75,
        comments: 12,
        shares: 5,
        content:
            'Dart 2.12 brings sound null safety, improving your codes reliability and performance.',
        communityId: '2'),
    // Add more posts here
  ];
  final List<Post> _popularPosts = [
    Post(
        communityName: 'android',
        duration: '2d',
        upVotes: 200,
        comments: 50,
        shares: 25,
        content: 'Exploring the new Android 12 features.',
        communityId: '3'),
    Post(
        communityName: 'ios',
        duration: '1d',
        upVotes: 150,
        comments: 40,
        shares: 20,
        content: 'What\'s new in iOS 15? Let\'s dive in.',
        communityId: '4'),
    // Add more "Popular" posts here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
      } else if (index == 1) {
        Navigator.pushNamed(context, '/communities');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/create_post');
      } else if (index == 3) {
        Navigator.pushNamed(context, '/chat');
      } else if (index == 4) {
        Navigator.pushNamed(context, '/inbox');
      }
    });
  }

  Widget _buildPostCard(Post post) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the start
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'r/${post.communityName} ${post.duration != null ? '• ${post.duration}' : ''}',
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Join'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepOrange),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8), // Add space between the header and content
            Text(post.content,
                style: TextStyle(fontSize: 14)), // Display post content
            SizedBox(height: 8), // Add space before the bottom row
            // Bottom row (votes, comments, shares) as previously implemented
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_upward),
                      onPressed: () {},
                    ),
                    Text('${post.upVotes}'),
                    IconButton(
                      icon: Icon(Icons.arrow_downward),
                      onPressed: () {},
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {},
                    ),
                    Text('${post.comments}'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {},
                    ),
                    Text('${post.shares}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;

    fetchAndSetCommunities(context);

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

    final List<Post> _postsToShow =
        _selectedPage == 'Home' ? _homePosts : _popularPosts;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: DropdownButton<String>(
          value: _selectedPage,
          items: [
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
          style: TextStyle(
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
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print('Search clicked');
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              print('Profile clicked');
            },
          ),
        ],
      ),
      drawer: communityDrawer(
        userID: user!.email,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _postsToShow.length,
          itemBuilder: (context, index) => _buildPostCard(_postsToShow[index]),
        ), // Placeholder for other pages
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Communities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.deepOrange,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
