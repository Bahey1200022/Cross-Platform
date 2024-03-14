import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarakel/models/user.dart';
import 'package:http/http.dart' as http;

import '../models/community.dart';
import '../providers/user_communities.dart';

class HomescreenController {
  Future<List<Community>> loadCommunities() async {
    try {
      // Make a GET request to fetch the JSON data from the server
      var response =
          await http.get(Uri.parse('http://localhost:3000/communities'));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the JSON response into a list
        List<dynamic> jsonData = json.decode(response.body);

        // Map the community data to Community objects
        List<Community> fetchedCommunities = jsonData.map((communityData) {
          return Community(
            id: communityData['id'],
            name: communityData['name'],
            description: communityData['description'],
            image: communityData['image'],
          );
        }).toList();

        return fetchedCommunities; // Return the fetched communities list
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

  Future<void> fetchAndSetCommunities(BuildContext context) async {
    try {
      List<Community> fetchedCommunities = await loadCommunities();
      Provider.of<UserCommunitiesProvider>(context, listen: false)
          .setCommunity(fetchedCommunities);
    } catch (e) {
      print('Error loading communities: $e');
      // Handle the error as needed
    }
  }
}
