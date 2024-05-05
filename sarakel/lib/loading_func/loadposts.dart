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

///function to extracte the duration into a string
String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  final Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays}d';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m';
  } else {
    return '${difference.inSeconds}s';
  }
}

Future<List<Post>> fetchPosts(String url) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await http.get(Uri.parse('$BASE_URL/$url'), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<dynamic> fetchedPosts =
          jsonData['data']; // replace jsonData['data'] with your actual data

      //print(fetchedPosts);
      List<Post> posts = fetchedPosts.map((p) {
        return Post(
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
            comments: p['numberOfComments'],
            shares: p['numberOfComments'] ?? 0,
            isNSFW: p['nsfw'],
            postCategory: "general",
            isSpoiler: p['isSpoiler'],
            content: p['content']?.toString() ?? "",
            communityId: p['communityId'],
            title: p['title'],
            username: p['username'],
            duration: formatDateTime(p['createdAt']),
            views: p['numViews'] ?? 0);
      }).toList();

      return posts.reversed.toList();
    } else {
      throw Exception('Failed to load  posts');
    }
  } catch (e) {
    throw Exception('Error loading  posts: $e');
  }
}
