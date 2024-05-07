// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ChatPermissions extends StatefulWidget {
  final String token;
  const ChatPermissions({super.key, required this.token});
  @override
  _ChatPermissionsState createState() => _ChatPermissionsState();
}

class _ChatPermissionsState extends State<ChatPermissions> {
  bool anyOneOnSarakel = true;
  bool acountOlderThan30Days = true;
  // ignore: non_constant_identifier_names
  bool Nobody = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Permissions'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text(
              'Chat requests',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text('Anyone on Sarakel'),
            trailing: Checkbox(
              value: anyOneOnSarakel,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  anyOneOnSarakel = value as bool;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Acount older than 30 days'),
            trailing: Checkbox(
              value: acountOlderThan30Days,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  acountOlderThan30Days = value as bool;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Nobody'),
            trailing: Checkbox(
              value: Nobody,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  Nobody = value as bool;
                });
              },
            ),
          ),
          const ListTile(
            title: Text(
              'Direct messages',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text('Anyone on Sarakel'),
            trailing: Checkbox(
              value: anyOneOnSarakel,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  anyOneOnSarakel = value as bool;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Nobody'),
            trailing: Checkbox(
              value: Nobody,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  Nobody = value as bool;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
