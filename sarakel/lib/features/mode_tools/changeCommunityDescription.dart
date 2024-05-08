// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

/// A page to change the description of a community.
class ChangeCommunityDescriptionPage extends StatefulWidget {
  final String token;
  final String communityName;
  final String description;

  const ChangeCommunityDescriptionPage({
    super.key,
    required this.token,
    required this.communityName,
    required this.description,
  });

  @override
  _ChangeCommunityDescriptionPageState createState() =>
      _ChangeCommunityDescriptionPageState();
}

class _ChangeCommunityDescriptionPageState extends State<ChangeCommunityDescriptionPage> {
  late TextEditingController _newDescriptionController;

  @override
  void initState() {
    super.initState();
    _newDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _newDescriptionController.dispose();
    super.dispose();
  }

Future<void> _changeCommunityDescription(
    String newDescription) async {
  final url = '$BASE_URL/api/r/${widget.communityName}/edit_community';
  final response = await http.patch(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    },
    body: jsonEncode({
      'description': newDescription,
    }),
  );

  if (response.statusCode == 200) {
    print('Successfully changed community Description to $newDescription ${response.body}');
  } else {
    print('Failed to change community Description. Error: ${response.body}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Community description'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Community Description: ${widget.description}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _newDescriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter New Description',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final newDescription = _newDescriptionController.text;
                  if (newDescription.isNotEmpty) {
                    _changeCommunityDescription(newDescription);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Please enter a new description.'),
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
                child: const Text('Change Description'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
