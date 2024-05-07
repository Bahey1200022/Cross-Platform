// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/Widgets/profiles/communityprofile_page.dart';
import 'package:sarakel/constants.dart';
import 'package:sarakel/models/community.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Create Community Controller to get the name, type, NSFW then push to the community profile page
class CreateCommunityController {
  static Future<void> createCommunity(String communityName,
      String communityType, bool is18Plus, BuildContext context) async {
    print('Creating community...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      print('No token found');
      return;
    }
    print('Token retrieved: $token');

    String formattedCommunityName = communityName;
    String communityId = communityName.toLowerCase().replaceAll(' ', '_');

    ///API from the backend to create a community
    var uri = Uri.parse('$BASE_URL/api/community/create');
    var request = http.MultipartRequest('POST', uri)
      ..fields['communityName'] = formattedCommunityName
      ..fields['type'] = communityType
      ..fields['isNSFW'] = is18Plus.toString();

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    var response = await request.send();
    print('Response status code: ${response.statusCode}');

    ///If the response is successful, push to the community profile page
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Community created successfully with ID: $communityId');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CommunityProfilePage(
            community: Community(
              id: communityId,
              name: communityName,
              type: communityType,
              is18Plus: is18Plus,
              description: '',
              image: '',
            ),
            token: token,
          ),
        ),
      );
    } else {
      print('Failed to create community. Error: ');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Community name already exists'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
