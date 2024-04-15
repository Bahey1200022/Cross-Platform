import 'package:sarakel/constants.dart';
import 'package:sarakel/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sarakel/user_profile/user_controller.dart';

class SavedController {
  Future<List<Post>> fetchSavedPosts() async {
    try {
      var response = await http.get(Uri.parse('$BASE_URL/subreddit/getBest'));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> fetchedPosts = jsonData['data'];

        List<Post> savedPosts = fetchedPosts.map((p) {
          return Post(
              communityName: p['communityName'] ?? "",
              id: p['_id'],
              imagePath: p['media'] != null
                  ? (p['media'] is List
                      ? (p['media'] as List).join(', ')
                      : extractUrl(p['media'].toString()))
                  : null,
              upVotes: p['upvotes'] ?? 0,
              downVotes: p['downvotes'] ?? 0,
              comments: p['numComments'],
              shares: p['numComments'],
              isNSFW: false,
              isSpoiler: p['isSpoiler'],
              content: p['content'] ?? "",
              communityId: p['communityId'] ?? "",
              title: p['title'] ?? "",
              username: p['userId'],
              views: p['numViews'] ?? 0);
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
