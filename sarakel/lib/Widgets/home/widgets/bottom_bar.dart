import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/chatting/chat_page.dart';
import 'package:sarakel/Widgets/chatting/one_on_one.dart';
import 'package:sarakel/Widgets/explore_communities/explore_communities.dart';
import 'package:sarakel/Widgets/home/controllers/home_screen_controller.dart';
import 'package:sarakel/Widgets/home/homescreen.dart';
import 'package:sarakel/Widgets/inbox/inbox_page.dart';
import 'package:sarakel/features/create_circle/create_circle.dart';
import 'package:sarakel/features/create_post/create_post.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final String token;
  // final Function(int) onTap;

  const CustomBottomNavigationBar(
      {Key? key, required this.currentIndex, required this.token
      // required this.onTap,
      })
      : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    // onTap(index); // Pass the index to the onTap function provided externally
    // Handle navigation here if needed
    if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExploreCommunities(token: token)));
    } else if (index == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreatePost(token: token)));
    } else if (index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SarakelHomeScreen(
                  homescreenController: HomescreenController(token: token))));
    } else if (index == 3) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ChatSection(token: token)));
    } else if (index == 4) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => InboxSection(token: token)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Circles',
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
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      backgroundColor: Colors.deepOrange,
      type: BottomNavigationBarType.fixed,
    );
  }
}
