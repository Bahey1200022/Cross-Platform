// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';
import 'package:sarakel/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/post.dart';

///one temporary list of posts
///getting the username from the token
class HomescreenController {
  final String token; //
  HomescreenController({required this.token});

  String getusername() {
    Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(token);
    if (jwtdecodedtoken['username'] == null) {
      return 'hi';
    } else {
      return jwtdecodedtoken['username'];
    }
  }

  User getUser() {
    saveUsername(getusername());
    return User(username: getusername(), token: token);
  }

  Future<void> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  String extractUrl(String s) {
    RegExp exp =
        RegExp(r'\[(.*?)\]'); // Regex pattern to match text within brackets
    Match? match = exp.firstMatch(s);
    return match != null
        ? match.group(1)!
        : s; // Return the URL without brackets, or the original string if no match is found
  }

  Future<List<Post>> loadPosts() async {
    try {
      var response =
          await http.get(Uri.parse('$BASE_URL/api/subreddit/getBest'));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> fetchedPosts = jsonData['data'];
        print(fetchedPosts);
        List<Post> posts = fetchedPosts.map((p) {
          return Post(
              communityName: p['communityName']?.toString() ?? "",
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
              isSpoiler: p['isSpoiler'] ?? false,
              content: p['content']?.toString() ?? "",
              communityId: p['communityId']?.toString() ?? "",
              title: p['title']?.toString() ?? "",
              username: p['userId']?.toString() ?? "",
              postCategory: "general",
              views: p['numViews'] ?? 0);
        }).toList();

        return posts;
      } else {
        return <Post>[];
      }
    } catch (e) {
      print('Error loading posts: $e');
      // Return an empty list if an error occurs
      return <Post>[];
    }
  }
}
