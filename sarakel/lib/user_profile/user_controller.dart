import 'dart:convert';
import 'package:sarakel/models/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sarakel/constants.dart';
import 'package:sarakel/models/post.dart';
import 'package:http/http.dart' as http;

///fetching all user data for his profile
String extractUrl(String s) {
  RegExp exp =
      RegExp(r'\[(.*?)\]'); // Regex pattern to match text within brackets
  Match? match = exp.firstMatch(s);
  return match != null
      ? match.group(1)!
      : s; // Return the URL without brackets, or the original string if no match is found
}

Future<List<Post>> loadUserPosts(String username) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    //print(username);
    var response = await http.get(
        Uri.parse('$BASE_URL/api/user/$username/submitted'),
        headers: <String, String>{'Authorization': 'Bearer $token'});
    //print(response.statusCode);
    if (response.statusCode == 200) {
      // print("inside the if");
      var jsonData = json.decode(response.body);
      //print(jsonData['posts']);
      List<dynamic> fetchedPosts = jsonData['posts'];

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
            isNSFW: false,
            isSpoiler: p['isSpoiler'] ?? false,
            content: p['content']?.toString() ?? "",
            communityId: p['communityId']?.toString() ?? "",
            title: p['title']?.toString() ?? "",
            username: p['username']?.toString() ?? "",
            views: p['numViews'] ?? 0);
      }).toList();
      return posts;
    } else {
      return [];
    }
  } catch (e) {
    // Return an empty list if an error occurs
    return <Post>[];
  }
}

Future<List<Comment>> loadUserComments(String username) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await http.get(
        Uri.parse('$BASE_URL/api/user/$username/comments'),
        headers: <String, String>{'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<dynamic> fetchedComments = jsonData['userComments'];
      return fetchedComments.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments: ${response.body}');
    }
  } catch (e) {
    // Return an empty list if an error occurs
    return <Comment>[];
  }
}

void addSocialLink(String links) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    // Create a map of the preferences you want to update
    var updateUrl = {
      'socialLinks': links,
      // Add other preferences here
    };
    var data = json.encode(updateUrl);
    // Make a PATCH request to update the user's preferences
    var response = await http.patch(
      Uri.parse('$BASE_URL/api/v1/me/prefs/?'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: data,
    );
    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // print('-------------------------------------------');
      // print('added social links successfully');
      // Preferences updated successfully
    } else {
      // Failed to update preferences
    }
  } catch (e) {}
}

Future<String> getUserUrl() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await http.get(Uri.parse('$BASE_URL/api/v1/me'),
        headers: <String, String>{'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      // Check if the "user" object exists in the JSON data
      if (jsonData.containsKey('user')) {
        var user = jsonData['user'];
        // print('-------------------profile----------SS');
        // print(user);

        // Check if the "socialLinks" field exists within the "user" object
        if (user.containsKey('socialLinks')) {
          var socialLinks = user['socialLinks'];

          // Now you have access to the "socialLinks" array
          // You can loop through it or access specific elements as needed
          // print('Social Links: $socialLinks');
          return socialLinks.join(', ');
        } else {
          // print('Social Links not found in JSON data.');
          throw Exception(
              'Social Links not found in JSON data.: ${response.body}');
        }
      } else {
        throw Exception('User not found in JSON data.');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  } catch (e) {
    return e.toString();
  }
}
