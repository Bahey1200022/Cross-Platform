import 'package:flutter/material.dart';
import '../models/post.dart';

class SarakelHomeScreen extends StatefulWidget {
  @override
  State<SarakelHomeScreen> createState() => _SarakelHomeScreenState();
}

class _SarakelHomeScreenState extends State<SarakelHomeScreen> {
  int _selectedIndex = 0;

  final List<Post> _posts = [
    Post(
        communityName: 'flutter',
        duration: '4h',
        upVotes: 120,
        comments: 30,
        shares: 15,
        content: 'Did you check out the brand new feature!!!!'),
    Post(
        communityName: 'dart',
        duration: '23h',
        upVotes: 75,
        comments: 12,
        shares: 5,
        content:
            'Dart 2.12 brings sound null safety, improving your codes reliability and performance.'),
    // Add more posts here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
      } else if (index == 1) {
        Navigator.pushNamed(context, '/communities');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/create_post');
      } else if (index == 3) {}
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            print('Communities navigation clicked');
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
      body: Center(
        child: _selectedIndex == 0
            ? ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) => _buildPostCard(_posts[index]),
              )
            : Text('Page Placeholder'), // Placeholder for other pages
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
