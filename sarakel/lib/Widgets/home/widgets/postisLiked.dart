import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

///functions to check if the post is liked or disliked

Future<bool> getids(String route, String postId, int type) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.get(
    Uri.parse('$BASE_URL$route'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    List<dynamic> jsonList;
    if (type == 1) {
      jsonList = jsonMap['upvotedPostsIds'];
    } else {
      jsonList = jsonMap['downvotedPostsIds'];
    }

    List<String> entityIds =
        jsonList.map((item) => item['entityId'] as String).toList();
    if (entityIds.contains(postId)) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> isLiked(String postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString('username');
  bool result = await getids('/api/user/$username/upvotedids', postId, 1);
  return result;
}

Future<bool> isDisliked(String postId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString('username');
  bool result = await getids('/api/user/$username/downvotedids', postId, 2);
  return result;
}
