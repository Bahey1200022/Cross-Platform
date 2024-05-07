// ignore_for_file: avoid_print

import 'package:sarakel/constants.dart';
import 'package:sarakel/loading_func/loadposts.dart';
import 'package:sarakel/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

///loading user history upvotes and downvotes
Future<List<Post>> loadRecentHistory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response =
      await http.get(Uri.parse('$BASE_URL/api/recentlyViewedPosts'), headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  });
  if (response.statusCode == 200) {
    var jsonData = response.body;
    var data = jsonDecode(jsonData);
    var posts = data['message']['result'];
    List<Post> post = [];
    for (var p in posts) {
      post.add(Post(
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
          duration: formatDateTime(p['createdAt']),
          title: p['title'],
          username: p['username'],
          views: p['numViews'] ?? 0));
    }
    return post;
  } else {
    return [];
  }
}

Future<List<Post>> loadUpvotedHistory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var username = prefs.getString('username');
  var response = await http
      .get(Uri.parse('$BASE_URL/api/user/$username/upvoted'), headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  });
  if (response.statusCode == 200) {
    var jsonString = response.body;
    var data = jsonDecode(jsonString);
    var upvotes = data['upvotes'];

    List<Map<String, dynamic>> posts = [];

    for (var upvote in upvotes) {
      if (upvote[0] == 'post') {
        posts.add(upvote[1][0]);
      }
    }
    print(posts);
    List<Post> post = [];
    for (var p in posts) {
      post.add(Post(
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
          views: p['numViews'] ?? 0));
    }
    return post;
  } else {
    return [];
  }
}

Future<List<Post>> loadDownvotedHistory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var username = prefs.getString('username');
  var response = await http
      .get(Uri.parse('$BASE_URL/api/user/$username/downvoted'), headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  });
  if (response.statusCode == 200) {
    var jsonString = response.body;
    var data = jsonDecode(jsonString);
    var upvotes = data['upvotes'];

    List<Map<String, dynamic>> posts = [];

    for (var upvote in upvotes) {
      if (upvote[0] == 'post') {
        posts.add(upvote[1][0]);
      }
    }
    print(posts);
    List<Post> post = [];
    for (var p in posts) {
      post.add(Post(
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
          duration: formatDateTime(p['createdAt']),
          postCategory: "general",
          isSpoiler: p['isSpoiler'],
          content: p['content']?.toString() ?? "",
          communityId: p['communityId'],
          title: p['title'],
          username: p['username'],
          views: p['numViews'] ?? 0));
    }
    return post;
  } else {
    return [];
  }
}
