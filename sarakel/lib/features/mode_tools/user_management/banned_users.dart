import 'package:flutter/material.dart';

class BannedUsersPage extends StatefulWidget {
  @override
  _BannedUsersPageState createState() => _BannedUsersPageState();
}

class _BannedUsersPageState extends State<BannedUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'Banned Users',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add your search functionality here
            },
          ),
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              // Add functionality to add a new user
            },
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Text('Banned Users Content'),
        ),
      ),
    );
  }
}
