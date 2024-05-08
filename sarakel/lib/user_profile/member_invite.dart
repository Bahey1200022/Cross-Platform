import 'package:flutter/material.dart';
import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void inviteAsmember(BuildContext context, String user) async {
  TextEditingController textController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Invite as Member'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: 'Enter Community you want to invite $user to',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle invite button press
              String inputText = textController.text;
              // Perform invite logic here
              request(user, inputText, context);
            },
            child: const Text('Invite'),
          ),
          TextButton(
            onPressed: () {
              // Handle cancel button press
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

void request(String user, String community, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  var response = await http.post(
      Uri.parse('$BASE_URL/r/$community/api/invite_to_join/$user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
  print(response.body);
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invitation sent successfully'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to send invitation as ${response.body}'),
      ),
    );
  }
}
