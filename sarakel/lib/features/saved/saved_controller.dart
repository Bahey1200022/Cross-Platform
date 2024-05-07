// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:sarakel/loading_func/loadposts.dart';
import 'package:sarakel/models/post.dart';
import 'package:sarakel/models/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Controller for fetching saved posts and comments
class SavedPostsController {
  Future<List<Post>> fetchSavedPosts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      print('token: $token');
      var response = await http.get(
        Uri.parse('$BASE_URL/api/get_save'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // print('response Body: ${response.body}');
      // print('response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> message = jsonData['message'];

        // Iterate over the message list to find the post data
        List<Post> posts = [];
        for (var item in message) {
          if (item.isNotEmpty && item[0] == "post") {
            List<dynamic> postList = item[1];
            for (var postData in postList) {
              if (postData.isNotEmpty) {
                var p = postData[0];

                posts.add(Post(
                  communityName: p['communityId'],
                  id: p['_id'],
                  imagePath: p['media'] != null
                      ? (p['media'] is List && (p['media'] as List).isNotEmpty
                          ? Uri.encodeFull(
                              extractUrl((p['media'] as List).first.toString()))
                          : Uri.encodeFull(extractUrl(p['media'].toString())))
                      : null,
                  upVotes: p['upvotes'],
                  downVotes: p['downvotes'],
                  comments: p['numberOfComments'] ?? 0,
                  shares: p['numberOfComments'] ?? 0,
                  isNSFW: p['nsfw'],
                  postCategory: "general",
                  isSpoiler: p['isSpoiler'],
                  content: p['content']?.toString() ?? "",
                  communityId: p['communityId'],
                  title: p['title'],
                  duration: formatDateTime(p['createdAt']),
                  username: p['username'],
                  views: p['numViews'] ?? 0,
                ));
              }
            }
          }
        }

        print('Number of Posts Created: ${posts.length}');
        return posts.reversed.toList();
      } else {
        throw Exception('Failed to load saved posts');
      }
    } catch (e) {
      print('Error loading saved posts: $e');
      throw Exception('Error loading saved posts: $e');
    }
  }
}

/// Controller for fetching saved comments
class SavedCommentsController {
  Future<List<Comment>> fetchSavedComments() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      if (token == null) {
        throw Exception('No token found');
      }
      print('token: $token');

      var response = await http.get(
        Uri.parse('$BASE_URL/api/get_save'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('response Body: ${response.body}');
      print('response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> message = jsonData['message'];

        List<Comment> comments = [];
        for (var item in message) {
          if (item.isNotEmpty && item[0] == "comment") {
            List<dynamic> commentList =
                item[1]; 
            for (var commentData in commentList) {
              if (commentData is Map<String, dynamic>) {
                comments.add(Comment.fromJson(commentData));
              } else {
                print('Invalid comment data format: $commentData');
              }
            }
          }
        }
        return comments;
      } else {
        throw Exception(
            'Failed to fetch saved comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching saved comments: $e');
      throw Exception('Error fetching saved comments: $e');
    }
  }
}
