// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:sarakel/loading_func/loadposts.dart';
import 'package:sarakel/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> fromjson(String route) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  var response = await http.get(Uri.parse('$BASE_URL$route'), headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  });

  ///api/r/$community/about/modqueue

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print('data: $data');
    List<dynamic> postList = data['posts'];
    List<Post> posts = postList.map((p) {
      return Post(
        communityName: p['communityId']?.toString() ?? "",
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
        isNSFW: p['nsfw:'] ?? false,
        duration: formatDateTime(p['createdAt']),
        isSpoiler: p['isSpoiler'] ?? false,
        content: p['content']?.toString() ?? "",
        title: p['title']?.toString() ?? "",
        username: p['username']?.toString() ?? "",
      );
    }).toList();
    print('completed');
    return posts;
  } else {
    throw Exception('Failed to load post');
  }
}

Future<List<Post>> getUnmoderated(String community) async {
  return fromjson('/api/r/$community/about/modqueue');
}

Future<List<Post>> getEdited(String community) async {
  return fromjson('/api/r/$community/about/edited');
}

Future<List<Post>> getRemovedPosts(String community) async {
  return fromjson('/api/r/$community/about/removed');
}

Future<List<Post>> getReportedPosts(String community) async {
  return fromjson('/api/r/$community/about/reports');
}
