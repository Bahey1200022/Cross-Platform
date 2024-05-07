// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void viewPost(String postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  print(postId);
  var response = await http.post(Uri.parse('$BASE_URL/api/viewPost'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'postId': postId,
      }));
  print('object');
  if (response.statusCode == 200) {
    print('Post viewed successfully');
  } else {
    throw Exception('Failed to view post');
  }
}
