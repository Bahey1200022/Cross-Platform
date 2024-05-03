import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void viewPost(String postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var username = prefs.getString('username');

  var response = await http.post(Uri.parse('$BASE_URL/api/$username/viewPost'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'postId': postId,
      }));
  if (response.statusCode == 200) {
    print('Post viewed successfully');
  } else {
    throw Exception('Failed to view post');
  }
}
