import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sarakel/Widgets/home/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user.dart';
import '../../../providers/user_provider.dart';
import '../../home/controllers/home_screen_controller.dart';

class UserController {
  String? usernameScreen;
  String emailScreen;
  String passwordScreen;
  SharedPreferences? prefs;
  UserController(
      {this.usernameScreen,
      required this.emailScreen,
      required this.passwordScreen});

  Future<bool> userExists(String email, String password) async {
    final response =
        await http.get(Uri.parse('http://192.168.34.134:3000/users'));

    if (response.statusCode == 200) {
      // Decode the response body from JSON
      final dynamic users = json.decode(response.body);
      // Iterate through the list of users
      for (var user in users) {
        // Check if the provided username matches any existing username
        if (user['email'] == email && user['password'] == password) {
          usernameScreen = user['username'];
          emailScreen = user['email'];
          passwordScreen = user['password'];
          return true; // Username exists
        }
      }
      return false; // Username doesn't exist
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<bool> usernameExists(String username) async {
    final response = await http
        .get(Uri.parse('http://192.168.34.134:3000/users?username=$username'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body).isNotEmpty;
    } else {
      return false;
    }
  }

  void passToServer(BuildContext context) async {
    var data = {
      "email": emailScreen,
      "password": passwordScreen,
      "token": "true",
      "username": usernameScreen
    };
    var url = Uri.parse('http://192.168.34.134:3000/users');

    try {
      var response = await http.post(
        url,
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushNamed(context, '/login');

        //     ////////////////
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
    }
  }

  Future<bool> loginUser(
      BuildContext context, String email, String password) async {
    var data = {"username": email, "password": password};
    print(data);
    try {
      var response = await http.post(
        Uri.parse('http://localhost:5000/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print(response.statusCode);
      var jsonData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        prefs = await SharedPreferences.getInstance();
        var token = jsonData['token'];
        print(jsonData);

        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(User(
            email: email,
            password: password,
            username: usernameScreen,
            token: token));
        prefs!.setString('token', token);
        print(jsonData);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SarakelHomeScreen(
                    homescreenController: HomescreenController(token: token))));
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      print('Caught error: $e');
      return false;
    }
  }
}
