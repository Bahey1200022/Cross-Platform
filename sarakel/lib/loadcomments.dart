import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';
import 'package:sarakel/models/comment.dart'; // Make sure you have a Comment model
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<List<Comment>> fetchComments(String postID) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  if (token == null) {
    throw Exception('No token found');
  }

  var response = await http.post(
    Uri.parse('$BASE_URL/api/get_post_replies'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'postID': postID}),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(
        response.body)['message']; // Adjust the key based on actual response
    return data.map((json) => Comment.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load comments: ${response.body}');
  }
}
