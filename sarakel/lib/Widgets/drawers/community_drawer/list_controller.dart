import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:sarakel/models/community.dart';
import 'package:http/http.dart' as http;

Future<List<Community>> loadCircles() async {
  try {
    // Make a GET request to fetch the JSON data from the server
    var response = await http.get(Uri.parse('$MOCK_URL/communities'));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Decode the JSON response into a list
      List<dynamic> jsonData = json.decode(response.body);

      // Map the community data to Community objects
      List<Community> fetchedCircles = jsonData.map((circleData) {
        return Community(
            id: circleData['id'],
            name: circleData['name'],
            description: circleData['description'],
            image: circleData['image'],
            is18Plus: circleData['is18Plus'],
            type: circleData['type']);
      }).toList();

      return fetchedCircles; // Return the fetched communities list
    } else {
      // Return an empty list if the response status code is not 200
      return [];
    }
  } catch (e) {
    print('Error loading communities: $e');
    // Return an empty list if an error occurs
    return [];
  }
}
