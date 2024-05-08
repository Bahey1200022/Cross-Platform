import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void approveOrRemove(String id, BuildContext context, String community) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Approve or Remove post?'),
        content: const Text('Do you want to approve or remove this post?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              approve(id, context, community);
              // Navigator.of(context).pop();
            },
            child: const Text('Approve'),
          ),
          TextButton(
            onPressed: () {
              remove(id, context, community);
              // Navigator.of(context).pop();
            },
            child: const Text('Remove'),
          ),
        ],
      );
    },
  );
}

void rate(String id, BuildContext context, String route) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  var url = '$BASE_URL$route';
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.headers['Authorization'] = 'Bearer $token';

// Add form fields
  request.fields['postId'] = id;

// Add file

  var response = await request.send();
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post rated successfully'),
      ),
    );
    Navigator.of(context).pop();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to rate post'),
      ),
    );
    Navigator.of(context).pop();

    // Request failed
    // Handle error
  }
}

void approve(String id, BuildContext context, String community) async {
  rate(id, context, '/r/$community/api/approve');
}

void remove(String id, BuildContext context, String community) async {
  rate(id, context, '/r/$community/api/remove');
}
