// ignore_for_file: avoid_print

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/loadposts.dart';
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

  Future<List<Post>> loadPosts() async {
    return fetchPosts('api/subreddit/getBest');
  }
}
