import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';
import 'package:sarakel/models/comment.dart'; // Make sure you have a Comment model
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<List<Comment>> fetchComments(String postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    throw Exception('No token found');
  }

  var response = await http.get(
    Uri.parse('$BASE_URL/api/get_post_replies/$postId'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Comment.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load comments: ${response.body}');
  }
}
