import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

class AddPostController {
  Future<void> addPost(String communityName, String communityId, String title,
      String body, String token, String url) async {
    try {
      if (title.trim().isNotEmpty) {
        const String apiUrl = '$BASE_URL/api/createPost/create';

        final Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };

        print('Token: $token');
        final Map<String, dynamic> postData = {
          'content': body,
          'title': title,
          //mediaUrl: url,
          //downvotes: 0,
          'communityId': communityName,
          //upvotes: 0,
          //scheduledAt: null,
          //isSpoiler: false,
          //isLocked: false,
          //isReported: false,
          //isReason: null,
          //nsfw: false,
          //ac: false,
          'url': url,
          //flair: null,
        };

        final String postJson = jsonEncode(postData);
        print('Post Data: $postJson');

        final http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: postJson,
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          //print('userId: $username');
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
