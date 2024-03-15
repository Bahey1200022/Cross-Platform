import 'package:flutter/material.dart';
import '../../models/post.dart';
import 'widgets/bottom_bar.dart';

class ChatSection extends StatefulWidget {
  @override
  State<ChatSection> createState() => _ChatSection();
}

class _ChatSection extends State<ChatSection> {
  int _selectedIndex = 3;

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
        bottomNavigationBar:
            CustomBottomNavigationBar(currentIndex: _selectedIndex));
  }
}
