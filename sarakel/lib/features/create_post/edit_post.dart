import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

///edit post function
void editpost(String postid, String post) async {
  // Edit post
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.post(
    Uri.parse('$BASE_URL/api/editusertext'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "type": "post",
      "entityId": postid,
      "newText": post,
    }),
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
  } else {
    throw Exception('Failed to edit post');
  }
}
