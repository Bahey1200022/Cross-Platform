import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

class AddPostController {
  Future<void> addPost(
      String communityName,
      String communityId,
      String title,
      String body,
      String token,
      String url,
      bool isSpoiler,
      bool isNSFW,
      bool isBA) async {
    try {
      if (title.trim().isNotEmpty) {
        const String apiUrl = '$BASE_URL/api/createPost/create';

        final Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };

        // ignore: avoid_print
        print('Token: $token');
        final Map<String, dynamic> postData = {
          'content': body,
          'title': title,
          //mediaUrl: url,
          //downvotes: 0,
          'communityId': communityName,
          //upvotes: 0,
          //scheduledAt: null,
          'isSpoiler': isSpoiler,
          //isLocked: false,
          //isReported: false,
          //isReason: null,
          'nsfw': isNSFW,
          'ac': isBA,
          'url': url,
          //flair: null,
        };

        final String postJson = jsonEncode(postData);
        // ignore: avoid_print
        print('Post Data: $postJson');

        final http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: postJson,
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          //print('userId: $username');
          // ignore: avoid_print
          print('Post added successfully');
        } else {
          // ignore: avoid_print
          print('Failed to add post. Status code: ${response.statusCode}');
          // ignore: avoid_print
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error adding post: $e');
    }
  }
}
