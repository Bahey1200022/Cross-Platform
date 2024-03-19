import 'dart:convert';

import 'package:http/http.dart' as http;

class AddPostController {
  Future<void> addPost(String communityName, String communityId, String title,
      String body) async {
    try {
      if (title.trim().isNotEmpty && body.trim().isNotEmpty) {
        final String apiUrl = 'http://192.168.1.17:3000/posts';

        final Map<String, String> headers = {
          'Content-Type': 'application/json'
        };

        final Map<String, dynamic> postData = {
          'title': title,
          'content': body,
          'communityId': communityId,
          'duration': "0",
          'upVotes': '0',
          'shares': '0',
          'downvotes': '0',
          'comments': "0",
          'communityName': communityName
        };

        final String postJson = jsonEncode(postData);

        final http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: postJson,
        );

        if (response.statusCode == 201) {
          print('Post added successfully');
        } else {
          print('Failed to add post. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      print('Error adding post: $e');
    }
  }
}
