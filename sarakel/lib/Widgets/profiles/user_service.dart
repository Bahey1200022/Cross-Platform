// user_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

enum UserRole {
  moderator,
  member,
  notMember,
  notLoggedIn,
}

Future<UserRole> fetchUserRoles(String token, String communityName) async {
  final url = '$BASE_URL/api/r/$communityName';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final String role = responseData['role'];

      switch (role) {
        case 'moderator':
          return UserRole.moderator;
        case 'member':
          return UserRole.member;
        case 'not a member':
          return UserRole.notMember;
        case 'not logged in':
          return UserRole.notLoggedIn;
        default:
          return UserRole.notLoggedIn;
      }
    } else {
      throw Exception('Failed to fetch user roles: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to fetch user roles: $e');
  }
}
