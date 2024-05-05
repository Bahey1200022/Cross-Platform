import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

///functions to check if the post is liked or disliked

void getmarked() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var username = prefs.getString('username');

  var response = await http.get(
    Uri.parse('$BASE_URL/api/user/$username/upvotedids'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    List<dynamic> jsonList = jsonMap['upvotedPostsIds'];
    List<String> entityIds =
        jsonList.map((item) => item['entityId'] as String).toList();
    prefs.setStringList('upvotedPostsIds', []);

    prefs.setStringList('upvotedPostsIds', entityIds);
  } else {
    prefs.setStringList('upvotedPostsIds', []);
  }

/////////////////////////////////////////////////////////////////////////////////////////
  var responsedown = await http.get(
    Uri.parse('$BASE_URL/api/user/$username/downvotedids'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (responsedown.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(responsedown.body);
    List<dynamic> jsonList = jsonMap['downvotedPostsIds'];
    List<String> entityIds =
        jsonList.map((item) => item['entityId'] as String).toList();
    prefs.setStringList('downvotedPostsIds', []);

    prefs.setStringList('downvotedPostsIds', entityIds);
  } else {
    prefs.setStringList('downvotedPostsIds', []);
  }
}

Future<bool> isLiked(String postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var uplist = prefs.getStringList('upvotedPostsIds');
  if (uplist == null) {
    return false;
  } else {
    bool result = uplist.contains(postId);
    return result;
  }
}

Future<bool> isDisliked(String postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var downlist = prefs.getStringList('downvotedPostsIds');
  if (downlist == null) {
    return false;
  } else {
    bool result = downlist.contains(postId);
    return result;
  }
}
