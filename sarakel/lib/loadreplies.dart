import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';
import 'package:sarakel/models/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<List<Comment>> fetchReplies(String postId, String commentId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    Uri url = Uri.parse('$BASE_URL/api/get_comment_replies');

    http.Response response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'postId': postId,
        'commentId': commentId,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> commentList = responseData['message'] ?? [];
      List<Comment> replies = commentList.map((json) => Comment.fromJson(json)).toList();
      return replies;
    } else if (response.statusCode == 400 && response.body.contains("Comment not found")) {
      print('Failed to load replies: Comment not found');
      return [];
    } else {
      print('Failed to load replies: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load replies');
    }
  } catch (e) {
    print('Failed to load replies: $e');
    throw Exception('Failed to load replies');
  }
}
