// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';
//import 'package:jwt_decoder/jwt_decoder.dart';

Future<bool> muteUser(
    String token, String username, String communityName) async {
  try {
    final String apiUrl = '$BASE_URL/r/$communityName/api/mute/$username';

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> postData = {
      'communityName': communityName,
      'usernameToMute': username,
    };

    final String postJson = jsonEncode(postData);

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: postJson,
    );

    if (response.statusCode == 200) {
      // User muted successfully
      return true;
    } else {
      // mutting failed
      print('Failed to mute the user. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    // Handle any errors
    print('Error mutting the user: $e');
    return false;
  }
}

Future<bool> unMuteUser(
    String token, String username, String communityName) async {
  try {
    final String apiUrl = '$BASE_URL/r/$communityName/api/unmute/$username';

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> postData = {
      'communityName': communityName,
      'usernameToUnmute': username,
    };

    final String postJson = jsonEncode(postData);

    final http.Response response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers,
      body: postJson,
    );

    if (response.statusCode == 200) {
      // User unmutted successfully
      return true;
    } else {
      // Unmutting failed
      print('Failed to unmute the user. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    // Handle any errors
    print('Error unmutting the user: $e');
    return false;
  }
}
