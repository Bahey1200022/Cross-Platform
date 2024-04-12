import 'package:flutter/material.dart';
import 'package:sarakel/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SavedController {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Post>> fetchSavedPosts() async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/savedPosts'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        List<Post> savedPosts = jsonData.map((p) {
          return Post(
            communityName: p['communityName'],
            duration: p['duration'],
            upVotes: p['upVotes'] ?? 0,
            downVotes: p['downVotes'] ?? 0,
            comments: p['comments'],
            shares: p['shares'],
            content: p['content'],
            imagePath: p['imagePath'],
            communityId: p['communityId'],
            title: p['title'], 
            id: 'id',
          );
        }).toList();

        return savedPosts;
      } else {
        throw Exception('Failed to load saved posts');
      }
    } catch (e) {
      throw Exception('Error loading saved posts: $e');
    }
  }
}