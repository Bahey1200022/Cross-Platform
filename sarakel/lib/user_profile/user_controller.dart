import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:sarakel/models/post.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> loadUserPosts() async {
  try {
    var response = await http.get(Uri.parse('$BASE_URL/subreddit/getBest'));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<dynamic> fetchedPosts = jsonData['data'];
      print(fetchedPosts);

      List<Post> posts = fetchedPosts.map((p) {
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
      return posts;
    } else {
      return [];
    }
  } catch (e) {
    print('Error loading posts: $e');
    // Return an empty list if an error occurs
    return <Post>[];
  }
}
