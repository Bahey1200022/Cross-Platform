// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';
//import 'package:jwt_decoder/jwt_decoder.dart';

Future<bool> banUser(
    String token, String username, String communityName) async {
  try {
    final String apiUrl = '$BASE_URL/r/$communityName/api/ban/$username';

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> postData = {
      'communityName': communityName,
      'usernameToBan': username,
    };

    final String postJson = jsonEncode(postData);

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: postJson,
    );

    if (response.statusCode == 200) {
      // User banned successfully
      return true;
    } else {
      // Banning failed
      print('Failed to ban the user. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    // Handle any errors
    print('Error banning the user: $e');
    return false;
  }
}

Future<bool> unBanUser(
    String token, String username, String communityName) async {
  try {
    final String apiUrl = '$BASE_URL/r/$communityName/api/unban/$username';

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> postData = {
      'communityName': communityName,
      'usernameToUnban': username,
    };

    final String postJson = jsonEncode(postData);

    final http.Response response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers,
      body: postJson,
    );

    if (response.statusCode == 200) {
      // User unbanned successfully
      return true;
    } else {
      // Unbanning failed
      print('Failed to unban the user. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    // Handle any errors
    print('Error unbanning the user: $e');
    return false;
  }
}
