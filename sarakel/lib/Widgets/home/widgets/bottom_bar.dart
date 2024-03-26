import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  // final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    // required this.onTap,
  }) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    // onTap(index); // Pass the index to the onTap function provided externally
    // Handle navigation here if needed
    if (index == 1) {
      Navigator.pushNamed(context, '/communities');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/create_post');
    } else if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/chat');
    } else if (index == 4) {
      Navigator.pushNamed(context, '/inbox');
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
