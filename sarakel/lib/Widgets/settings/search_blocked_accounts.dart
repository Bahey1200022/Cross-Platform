import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sarakel/constants.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchBlockedSuggestions(String query) async {
  print('fetching suggestions');
  print(query);
  var response = await http.post(Uri.parse('$BASE_URL/searchBy/users'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'keyword': query,
      }));
  print(response.statusCode);
  if (response.statusCode == 200) {
    var suggestionsList = json.decode(response.body);
    var suggestions = suggestionsList['usersResults'];

    List<dynamic> filteredSuggestions = [];
    for (var suggestion in suggestions) {
      filteredSuggestions.add(suggestion['username']);
    }

    print('ahhhh');
    print(filteredSuggestions);
    return filteredSuggestions;
  } else {
    throw Exception('Failed to load suggestions');
  }
}

Future<void> blockUser(String username) async {
  print(username);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.post(Uri.parse('$BASE_URL/api/block_user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'usernameToBlock': username,
      }));

  if (response.statusCode == 200) {
    print('User blocked successfully');
  } else {
    throw Exception('Failed to block user');
  }
}

Future<void> unblockUser(String username) async {
  print(username);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.post(Uri.parse('$BASE_URL/api/unblock_user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'usernameToUnblock': username,
      }));

  if (response.statusCode == 200) {
    print('User unblocked successfully');
  } else {
    throw Exception('Failed to unblock user');
  }
}

Future<String> getBlockedUsers() async {
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
        print(user);

        // Check if the "socialLinks" field exists within the "user" object
        if (user.containsKey('blockedUsers')) {
          var socialLinks = user['blockedUsers'];

          // Now you have access to the "socialLinks" array
          // You can loop through it or access specific elements as needed
          print('blockedUsers: $socialLinks');
          return socialLinks.join(', ');
        } else {
          print('blocked users not found in JSON data.');
          throw Exception(
              'Blocked users not found in JSON data.: ${response.body}');
        }
      } else {
        throw Exception('blocked users not found in JSON data.');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  } catch (e) {
    return e.toString();
  }
}
