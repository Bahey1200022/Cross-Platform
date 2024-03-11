import 'package:flutter/material.dart';
import '../models/post.dart';

class ChatSection extends StatefulWidget {
  @override
  State<ChatSection> createState() => _ChatSection();
}

class _ChatSection extends State<ChatSection> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 3) {
      } else if (index == 1) {
        Navigator.pushNamed(context, '/communities');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/create_post');
      } else if (index == 0) {
        Navigator.pushNamed(context, '/home');
      } else if (index == 4) {
        Navigator.pushNamed(context, '/inbox');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        leading: IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            print('Communities navigation clicked');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              print('Filter clicked');
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list_outlined),
            onPressed: () {
              print('Filter clicked');
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
        child: Text('Chat Page is under construction'),
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
