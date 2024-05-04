import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:sarakel/loading_func/loadposts.dart';
import 'package:sarakel/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SavedController {
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

      print('response Body: ${response.body}');
      print('response status code: ${response.statusCode}');
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
                print('postId: ${p['_id']}');
                print('processing post: $p');
                posts.add(Post(
                  communityName: "communityId",
                  id: p['_id']?.toString() ?? "",
                  imagePath: p['media'] != null
                      ? (p['media'] is List && (p['media'] as List).isNotEmpty
                          ? Uri.encodeFull(
                              extractUrl((p['media'] as List).first.toString()))
                          : Uri.encodeFull(extractUrl(p['media'].toString())))
                      : null,
                  upVotes: p['upvotes'] ?? 0,
                  downVotes: p['downvotes'] ?? 0,
                  comments: p['numComments'] ?? 0,
                  shares: p['numComments'] ?? 0,
                  isNSFW: true,
                  postCategory: "general",
                  isSpoiler: p['isSpoiler'] ?? false,
                  content: p['content']?.toString() ?? "",
                  communityId: p['communityId']?.toString() ?? "",
                  title: p['title']?.toString() ?? "",
                  username: p['userId']?.toString() ?? "",
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
