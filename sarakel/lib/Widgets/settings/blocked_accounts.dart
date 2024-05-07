// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class BlockedAccounts extends StatefulWidget {
  final String token;

  const BlockedAccounts({super.key, required this.token});

  @override
  _BlockedAccountsState createState() => _BlockedAccountsState();
}

class _BlockedAccountsState extends State<BlockedAccounts> {
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
        title: const Text('Blocked Accounts'),
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
