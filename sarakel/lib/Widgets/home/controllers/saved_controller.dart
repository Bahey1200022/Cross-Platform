import 'package:sarakel/constants.dart';
import 'package:sarakel/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SavedController {
  Future<List<Post>> fetchSavedPosts() async {
    try {
      var response = await http.get(Uri.parse('$BASE_URL/subreddit/getBest'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        List<Post> savedPosts = jsonData.map((p) {
          return Post(
              communityName: p['communityName'],
              id: p['postId'],
              duration: p['duration'],
              upVotes: p['upvotes'] ?? 0, // Provide a default value if null
              downVotes: p['downvotes'] ?? 0, // Provide a default value if null
              comments: p['numComments'],
              shares: p['numComments'],
              content: p['content'],
              communityId: p['communityId'],
              title: p['title'],
              username: p['userId'],
              views: p['numViews']);
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
