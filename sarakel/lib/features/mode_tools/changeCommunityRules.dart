// ignore_for_file: non_constant_identifier_names, file_names, use_super_parameters, library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

/// A page to change the rules of a community.
class ChangeCommunityRulesPage extends StatefulWidget {
  final String token;
  final String communityName;
  final String? currentRules; // Make it nullable

  const ChangeCommunityRulesPage({
    Key? key,
    required this.token,
    required this.communityName,
    this.currentRules, // Update parameter to accept nullable string
  }) : super(key: key);

  @override
  _ChangeCommunityRulesPageState createState() =>
      _ChangeCommunityRulesPageState();
}

class _ChangeCommunityRulesPageState extends State<ChangeCommunityRulesPage> {
  late TextEditingController _newRulesController;

  @override
  void initState() {
    super.initState();
    _newRulesController = TextEditingController(text: widget.currentRules);
  }

  @override
  void dispose() {
    _newRulesController.dispose();
    super.dispose();
  }

  Future<void> _changeCommunityRules(String newRules) async {
    final url = '$BASE_URL/api/r/${widget.communityName}/edit_community';
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        'communityName': widget.communityName,
        'rules': newRules,
      }),
    );

    if (response.statusCode == 200) {
      print(
          'Successfully changed community rules to $newRules ${response.body}');
    } else {
      print('Failed to change community rules. Error: ${response.body}');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Change Community Rules'),
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Current Rules:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              widget.currentRules ?? "No rules specified",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newRulesController,
              decoration: const InputDecoration(
                hintText: 'Enter New Rules',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newRules = _newRulesController.text;
                if (newRules.isNotEmpty) {
                  _changeCommunityRules(newRules);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Please enter new rules.'),
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
              child: const Text('Change Rules'),
            ),
          ],
        ),
      ),
    ),
  );
}
}