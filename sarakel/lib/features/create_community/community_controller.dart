import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCommunityController {
  //static Future<bool> checkCircleExists(String communityName) async {
  //final response = await http.get(
  //Uri.parse('$MOCK_URL/communities?name=$communityName'),
  //);

  //if (response.statusCode == 200) {
  //return jsonDecode(response.body).isNotEmpty;
  //} else {
  //return false;
  //}
  //}

  //static Future<bool> checkCircleIdExists(String communityId) async {
  //final response = await http.get(
  //Uri.parse('$MOCK_URL/communities?id=$communityId'),
  //);

  //if (response.statusCode == 200) {
  //return jsonDecode(response.body).isNotEmpty;
  //} else {
  //return false;
  //}
  //}

  static Future<void> createCommunity(
      String communityName, String communityType, bool is18Plus) async {
    print('Creating community...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      print('No token found');
      return;
    }
    print('Token retrieved: $token');
    //bool circleExists = await checkCircleExists(communityName);
    //bool idExists = await checkCircleIdExists(
    //communityName.toLowerCase().replaceAll(' ', '_'));

    //if (circleExists || idExists) {
    //print(
    //'Circle with the name "$communityName" already exists. Please choose a different name.');
    //return;
    //}

    String formattedCommunityName = communityName;
    String communityId = communityName.toLowerCase().replaceAll(' ', '_');

    Map<String, dynamic> communityData = {
      //"id": communityId,
      "communityName": formattedCommunityName,
      //"moderatorsUsernames": prefs.getString('username'),
      "type": communityType,
      "isNSFW": is18Plus, // Include 18+ flag in circle data
      //"image":
      //"https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0",
      //"description": "new circle"
    };

    final response = await http.post(
      Uri.parse('$BASE_URL/api/site_admin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(communityData),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Community created successfully with ID: $communityId');
    } else {
      print('Failed to create community. Error: ${response.body}');
    }
  }
}
