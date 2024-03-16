import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../feed/widgets/bottom_bar.dart';

class InboxSection extends StatefulWidget {
  @override
  State<InboxSection> createState() => _InboxSection();
}

class _InboxSection extends State<InboxSection> {
  int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          leading: IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              print('Communities navigation clicked');
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                print('more clicked');
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
          child: Text('Inbox Page is under construction'),
        ),
        bottomNavigationBar:
            CustomBottomNavigationBar(currentIndex: _selectedIndex));
  }
}
