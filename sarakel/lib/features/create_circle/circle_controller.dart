import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateCircleController {
  static Future<bool> checkCircleExists(String communityName) async {
    final response = await http.get(
      Uri.parse('http://192.168.34.134:3000/communities?name=$communityName'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body).isNotEmpty;
    } else {
      return false;
    }
  }

  static Future<bool> checkCircleIdExists(String communityId) async {
    final response = await http.get(
      Uri.parse('http://192.168.34.134:3000/communities?id=$communityId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body).isNotEmpty;
    } else {
      return false;
    }
  }

  static Future<void> createCircle(
      String communityName, String circleType, bool is18Plus) async {
    bool circleExists = await checkCircleExists(communityName);
    bool idExists = await checkCircleIdExists(
        communityName.toLowerCase().replaceAll(' ', '_'));

    if (circleExists || idExists) {
      print(
          'Circle with the name "$communityName" already exists. Please choose a different name.');
      return;
    }

    String formattedCommunityName = 'c/$communityName';
    String communityId = communityName.toLowerCase().replaceAll(' ', '_');

    Map<String, dynamic> circleData = {
      "id": communityId,
      "name": formattedCommunityName,
      "type": circleType,
      "is18Plus": is18Plus, // Include 18+ flag in circle data
      "image":
          "https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0",
      "description": "new circle"
    };

    final response = await http.post(
      Uri.parse('http://192.168.34.134:3000/communities'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(circleData),
    );

    if (response.statusCode == 201) {
      print('Circle created successfully with ID: $communityId');
    } else {
      print('Failed to create circle. Error: ${response.body}');
    }
  }
}
