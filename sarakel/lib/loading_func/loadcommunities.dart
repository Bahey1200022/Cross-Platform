// ignore_for_file: avoid_print, duplicate_ignore, non_constant_identifier_names

import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:sarakel/models/community.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<List<Community>> loadCommunities(String route) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print('yarab');
    var response = await http.get(Uri.parse('$BASE_URL$route'), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      // Decode the JSON response into a list
      var jsonData = json.decode(response.body);
      // ignore: non_constant_identifier_names

      List<dynamic> Data = jsonData['data'];
      //print(Data);
      // Map the community data to Community objects
      List<Community> fetchedCircles = Data.map((circleData) {
        return Community(
          id: circleData['_id'],
          name: circleData['communityName'] ?? "",
          description: circleData['description'] ?? "",
          backimage: circleData['backgroundPicUrl'] ??
              circleData['backgroundPic'] ??
              "https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0",
          image: circleData['displayPicUrl'] ??
              circleData['displayPic'] ??
              "https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0",
          is18Plus: circleData['isNSFW'],
          type: circleData['type'] ?? "public",
          rules: (circleData['rules']).join(' '),
        );
      }).toList();
      return fetchedCircles; // Return the fetched communities list
    } else {
      // Return an empty list if the response status code is not 200
      return [];
    }
  } catch (e) {
    // ignore: avoid_print
    print('Error loading communities: $e');
    // Return an empty list if an error occurs
    return [];
  }
}
