import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/constants.dart';
import 'package:sarakel/Widgets/explore_communities/join_button_controller.dart';

class LeaveCommunityController {
  static Future<void> leaveCommunity(String communityName, String token) async {
    try {
      final String apiUrl = '$BASE_URL/api/community/leave';

      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };

      String username = JoinCommunityController.getUsernameFromToken(token);
      if (username.isEmpty) {
        print('Failed to get username from token');
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
        print('Left community successfully');
      } else {
        print('Failed to leave community. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error leaving community: $e');
    }
  }
}
