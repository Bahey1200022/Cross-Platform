// ignore_for_file: library_private_types_in_public_api, use_super_parameters

import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/chatting/chat_page.dart';
import 'package:sarakel/Widgets/explore_communities/explore_communities.dart';
import 'package:sarakel/Widgets/home/controllers/home_screen_controller.dart';
import 'package:sarakel/Widgets/home/homescreen.dart';
import 'package:sarakel/Widgets/inbox/inbox_page.dart';
import 'package:sarakel/features/create_post/create_post.dart';
import 'package:sarakel/models/user.dart';

/// Custom common Bottom Navigation Bar
class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final String token;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.token,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected =
        List<bool>.generate(5, (index) => index == widget.currentIndex);
  }

  void _onItemTapped(BuildContext context, int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = (i == index);
      }
    });

    // Handle navigation here
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SarakelHomeScreen(
              homescreenController: HomescreenController(token: widget.token),
            ),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ExploreCommunities(token: widget.token, user: User()),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePost(
                token: widget.token,
                selectedDate: DateTime.now(),
                selectedTime: TimeOfDay.now(),
                onScheduled: (bool value) {}),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatSection(token: widget.token, user: User()),
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InboxSection(token: widget.token, user: User()),
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_search_outlined),
          activeIcon: Icon(Icons.person_search),
          label: 'Circles',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_outlined),
          activeIcon: Icon(Icons.add),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_outlined),
          activeIcon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Inbox',
        )
      ],
      currentIndex: widget.currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      selectedIconTheme: const IconThemeData(size: 30),
      unselectedFontSize: 12,
      selectedFontSize: 14,
    );
  }
}
