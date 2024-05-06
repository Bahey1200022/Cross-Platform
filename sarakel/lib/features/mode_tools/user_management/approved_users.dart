import 'package:flutter/material.dart';

class ApprovedUsersPage extends StatefulWidget {
  @override
  _ApprovedUsersPageState createState() => _ApprovedUsersPageState();
}

class _ApprovedUsersPageState extends State<ApprovedUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Text(
            'Approved Users',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add your search functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // Add functionality to add a new user
            },
          ),
        ],
      ),
      body: Container(
        child: const Center(
          child: Text('Approved Users Content'),
        ),
      ),
    );
  }
}
