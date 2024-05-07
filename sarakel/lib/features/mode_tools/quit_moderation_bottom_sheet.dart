import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/Widgets/home/controllers/home_screen_controller.dart';
import 'package:sarakel/Widgets/home/homescreen.dart';
import 'package:sarakel/constants.dart';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<bool> leaveModeration(String token, String communityName) async {
  try {
    final String apiUrl = '$BASE_URL/r/$communityName/api/leavemoderator';

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
      'username': loggedInUsername,
    };

    final String postJson = jsonEncode(postData);

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: postJson,
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      // Invitation failed
      print('Failed to leave moderation. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    // Handle any errors
    print('Error leaving moderation: $e');
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

class QuitModerationBottomSheet extends StatelessWidget {
  final String token;
  final String communityName;

  const QuitModerationBottomSheet({
    required this.token,
    required this.communityName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.remove_circle),
            title: Text('Leave'),
            onTap: () async {
              // Implement leave moderation logic
              try {
                bool success = await leaveModeration(token, communityName);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Left the community successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to leave the community')),
                  );
                }
                Navigator.pop(context); // Close the bottom sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SarakelHomeScreen(
                      homescreenController: HomescreenController(token: token),
                    ),
                  ),
                );
              } catch (error) {
                // Handle error
                print(error);
              }
            },
          ),
        ],
      ),
    );
  }
}
