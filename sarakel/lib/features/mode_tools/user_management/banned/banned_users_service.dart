// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

class BannedUsersService {
  static Future<List<String>> getBannedUsers(
      String token, String communityName) async {
    final url =
        '$BASE_URL/api/r/$communityName/about/banned'; // Replace with your backend API endpoint

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Set the authorization header
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        // If the request is successful
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> bannedList = responseData['bannedUsers'];
        return bannedList.map((e) => e.toString()).toList();
      } else {
        // If the request fails
        throw Exception('Failed to load banned users');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server');
    }
  }
}
