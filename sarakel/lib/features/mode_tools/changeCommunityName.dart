// ignore_for_file: file_names, non_constant_identifier_names, use_super_parameters, library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

/// A page to change the name of a community.
class ChangeCommunityNamePage extends StatefulWidget {
  final String token;
  final String communityName;

  const ChangeCommunityNamePage({
    Key? key,
    required this.token,
    required this.communityName,
  }) : super(key: key);

  @override
  _ChangeCommunityNamePageState createState() =>
      _ChangeCommunityNamePageState();
}

class _ChangeCommunityNamePageState extends State<ChangeCommunityNamePage> {
  late TextEditingController _newNameController;

  @override
  void initState() {
    super.initState();
    _newNameController = TextEditingController();
  }

  @override
  void dispose() {
    _newNameController.dispose();
    super.dispose();
  }

  Future<void> _changeCommunityName(String newName) async {
    final url = '$BASE_URL/api/r/${widget.communityName}/edit_community';
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        'communityName': newName,
      }),
    );

    if (response.statusCode == 200) {
      print('Successfully changed community name to $newName ${response.body}');
    } else {
      print('Failed to change community name. Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Community Name'),
        actions: [
          TextButton(
            onPressed: () {
              final newName = _newNameController.text;
              if (newName.isNotEmpty) {
                _changeCommunityName(newName);
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Please enter a new name.'),
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
            child: const Text('Save',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Community Name: ',
                style: const TextStyle(fontSize: 30),
              ),
              Text(
                widget.communityName,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _newNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter New Name',
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
