// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/constants.dart';

Future<bool> sendModeratorInvitation(
    String token, String username, String communityName) async {
  try {
    final String apiUrl = '$BASE_URL/r/$communityName/api/invite/$username';

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    String loggedInUsername = getUsernameFromToken(token);
    if (loggedInUsername.isEmpty) {
      return false;
    }

    final Map<String, dynamic> postData = {
      'communityName': communityName,
      'mod': loggedInUsername,
      'invitee': username,
    };

    final String postJson = jsonEncode(postData);

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: postJson,
    );

    if (response.statusCode == 200) {
      // Invitation sent successfully
      return true;
    } else {
      // Invitation failed
      print('Failed to send invitation. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    // Handle any errors
    print('Error sending invitation: $e');
    return false;
  }
}

String getUsernameFromToken(String token) {
  try {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String username = decodedToken['username'];
    return username;
  } catch (e) {
    return '';
  }
}
