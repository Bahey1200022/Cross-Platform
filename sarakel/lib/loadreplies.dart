import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';
import 'package:sarakel/models/reply.dart'; // Make sure you have a reply model
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<List<Reply>> fetchReplies(String postID) async {
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
    return data.map((json) => Reply.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Replies: ${response.body}');
  }
}
