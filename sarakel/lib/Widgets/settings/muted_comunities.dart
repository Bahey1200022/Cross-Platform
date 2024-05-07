// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class MutedCommunities extends StatefulWidget {
  final String token;

  const MutedCommunities({super.key, required this.token});

  @override
  _MutedCommunitiesState createState() => _MutedCommunitiesState();
}

class _MutedCommunitiesState extends State<MutedCommunities> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muted Communities'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
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
