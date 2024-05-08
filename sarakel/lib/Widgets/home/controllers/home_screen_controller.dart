// ignore_for_file: avoid_print

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/loading_func/loadposts.dart';
import 'package:sarakel/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/post.dart';

///Listing the posts on the home screen
class HomescreenController {
  final String token; //
  String? profilePic;
  HomescreenController({required this.token, this.profilePic});

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

  Future<List<Post>> loadNewPosts() async {
    return fetchPosts('api/subreddit/getNew');
  }

  Future<List<Post>> loadHotPosts() async {
    return fetchPosts('api/subreddit/getHot');
  }

  Future<List<Post>> loadRandomPosts() async {
    return fetchPosts('api/subreddit/getRandom');
  }
}
