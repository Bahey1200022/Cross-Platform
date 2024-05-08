import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:sarakel/models/community.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> getInvitations() async {
  // Simulate a network request
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  var response =
      await http.get(Uri.parse('$BASE_URL/api/v1/me/invites'), headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  });
  List<Map<String, dynamic>> invitations = [];

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);

    data['modInvitations'].forEach((name) {
      invitations
          .add({'type': 'You are invited to be a moderator', 'name': name});
    });

    data['memberInvitations'].forEach((name) {
      invitations.add({'type': 'You are invited to be a member', 'name': name});
    });
    return invitations;
  }
  return [];
}

Future<Community> getInfo(String communityName) async {
  var response = await http.get(
      Uri.parse(
          '$BASE_URL/api/community/$communityName/getCommunityInfoByName'),
      headers: {
        'Content-Type': 'application/json',
      });

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    var fromjson = data['data']['data'];

    Community community = Community(
      name: fromjson['communityName'],
      description: fromjson['description'] ?? "No description available",
      id: fromjson['_id'],
      image: fromjson['displayPic'] ??
          "https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0",
      is18Plus: fromjson['isNSFW'],
      type: fromjson['type'],
      backimage: fromjson['backgroundPic'] ??
          "https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0",
    );
    return community;
  } else {
    throw Exception('Failed to load community');
  }
}
