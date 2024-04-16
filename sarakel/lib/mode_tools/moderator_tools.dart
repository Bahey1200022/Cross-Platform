import 'package:flutter/material.dart';

class ModeratorTools extends StatefulWidget {
  final String token;
  ModeratorTools({required this.token});
  @override
  _ModeratorToolsState createState() => _ModeratorToolsState();
}

class _ModeratorToolsState extends State<ModeratorTools> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Muted Communities'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Add your content here
        ],
      ),
    );
  }
}
