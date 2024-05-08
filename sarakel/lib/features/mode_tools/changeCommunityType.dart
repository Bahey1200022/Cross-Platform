// ignore_for_file: non_constant_identifier_names, file_names, library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

/// A page to change the type of a community.
class ChangeCommunityTypePage extends StatefulWidget {
  final String token;
  final String communityName;
  final String type;

  const ChangeCommunityTypePage({
    super.key,
    required this.token,
    required this.communityName,
    required this.type,
  });

  @override
  _ChangeCommunityTypePageState createState() =>
      _ChangeCommunityTypePageState();
}

class _ChangeCommunityTypePageState extends State<ChangeCommunityTypePage> {
  late TextEditingController _newTypeController;

  @override
  void initState() {
    super.initState();
    _newTypeController = TextEditingController(text: widget.type);
  }

  @override
  void dispose() {
    _newTypeController.dispose();
    super.dispose();
  }

  Future<void> _changeCommunityType(String newType) async {
    final url = '$BASE_URL/api/r/${widget.communityName}/edit_community';
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        'communityName': widget.communityName,
        'type': newType,
      }),
    );

    if (response.statusCode == 200) {
      print(
          'Successfully changed community type to $newType ${response.body}');
    } else {
      print('Failed to change community type. Error: ${response.body}');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Change Community Type'),
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Current Type:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              widget.type,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newTypeController,
              decoration: const InputDecoration(
                hintText: 'Enter New TYPE',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newType = _newTypeController.text;
                if (newType.isNotEmpty) {
                  _changeCommunityType(newType);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Please enter new type.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Change Type'),
            ),
          ],
        ),
      ),
    ),
  );
}
}