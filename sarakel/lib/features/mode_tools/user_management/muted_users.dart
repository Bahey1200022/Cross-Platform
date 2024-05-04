import 'package:flutter/material.dart';

class MutedUsersPage extends StatefulWidget {
  @override
  _MutedUsersPageState createState() => _MutedUsersPageState();
}

class _MutedUsersPageState extends State<MutedUsersPage> {
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
            'Muted Users',
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
          child: Text('Muted Users Content'),
        ),
      ),
    );
  }
}
