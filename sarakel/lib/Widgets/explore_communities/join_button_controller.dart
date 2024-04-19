// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/constants.dart';

class JoinCommunityController {
  static String getUsernameFromToken(String token) {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String username = decodedToken['username'];
      return username;
    } catch (e) {
      return '';
    }
  }

  static Future<void> joinCommunity(String communityName, String token) async {
    try {
      const String apiUrl = '$BASE_URL/api/community/join';

      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };

      String username = getUsernameFromToken(token);
      if (username.isEmpty) {
        return;
      }

      final Map<String, dynamic> postData = {
        'communityName': communityName,
        'username': username,
      };

      final String postJson = jsonEncode(postData);

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: postJson,
      );

      if (response.statusCode == 200) {
        print('Joined community successfully');
      } else {
        print('Failed to join community. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error joining community: $e');
    }
  }
}
