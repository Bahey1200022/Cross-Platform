// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/user_management/banned/add_banned_users_controller.dart';
import 'package:sarakel/features/mode_tools/user_management/moderators/add_moderator_controller.dart';

class BanUserPage extends StatefulWidget {
  final String communityName;
  final String token;

  const BanUserPage({
    super.key,
    required this.communityName,
    required this.token,
  });

  @override
  _BanUserPageState createState() => _BanUserPageState();
}

class _BanUserPageState extends State<BanUserPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;

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
        title: const Text(
          'Ban User',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  _isFocused = value.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter username',
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorText: _isFocused && _controller.text.isEmpty
                    ? 'Username is required'
                    : null,
                suffixIcon: const Icon(Icons.person),
                labelText: _isFocused ? 'Username' : null,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final String username = _controller.text.trim();
                  banUser(widget.token, username, widget.communityName)
                      .then((bannedUser) {
                    if (bannedUser) {
                      // Banned user successfully
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Banned user successfully')),
                      );
                    } else {
                      // Banned user failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to ban the user')),
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF00BFA5),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: const StadiumBorder(), // Oval shape
                ),
                child: const Text('Ban'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
