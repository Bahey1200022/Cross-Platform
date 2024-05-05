import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

class ModerationService {
  static Future<List<String>> getModerators(
      String token, String communityName) async {
    final url =
        '$BASE_URL/api/r/$communityName/about/moderators'; // Replace with your backend API endpoint

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Set the authorization header
        },
      );
      //print(response.body);
      if (response.statusCode == 200) {
        // If the request is successful
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> moderatorsList = responseData['moderators'];
        return moderatorsList.map((e) => e.toString()).toList();
      } else {
        // If the request fails
        throw Exception('Failed to load moderators');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server');
    }
  }
}
