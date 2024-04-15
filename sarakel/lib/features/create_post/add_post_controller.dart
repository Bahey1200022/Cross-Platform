import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/constants.dart';

class AddPostController {
  Future<void> addPost(String communityName, String communityId, String title,
      String body,String token) async {
    try {
      if (title.trim().isNotEmpty && body.trim().isNotEmpty) {
        final String apiUrl = '$BASE_URL/createPost/create';

        final Map<String, String> headers = {
          'Content-Type': 'application/json'
        };

        print('Token: $token');
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        print('Decoded Token: $decodedToken');
        String username = decodedToken['username']; 
        print('Username: $username');
        final Map<String, dynamic> postData = {
          'title': title,
          'Content': body,
          'communityId': communityName,
          //'duration': "0",
          //'upVotes': 0,
          //'shares': '0',
          //'downvotes': 0,
          //'comments': "0",
          'communityName': communityName,
          'userId': username,
          'parentId':"0",
          'isLocked': false,
        };

        final String postJson = jsonEncode(postData);
        print('Post Data: $postJson');

        final http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: postJson,
        );

        if (response.statusCode == 201) {
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
