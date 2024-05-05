import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:sarakel/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// function to load posts from backend
String extractUrl(String s) {
  RegExp exp =
      RegExp(r'\[(.*?)\]'); // Regex pattern to match text within brackets
  Match? match = exp.firstMatch(s);
  return match != null
      ? match.group(1)!
      : s; // Return the URL without brackets, or the original string if no match is found
}

Future<List<Post>> fetchCommunityPosts(String communityName) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await http.get(
        Uri.parse('$BASE_URL/api/community/$communityName/getPosts'),
        headers: {
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<dynamic> fetchedPosts = jsonData['data'];

      List<Post> posts = fetchedPosts.map((p) {
        return Post(
            communityName: communityName,
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
            views: p['numViews'] ?? 0);
      }).toList();

      return posts.reversed.toList();
    } else {
      throw Exception('Failed to load community posts');
    }
  } catch (e) {
    throw Exception('Error loading community posts: $e');
  }
}
