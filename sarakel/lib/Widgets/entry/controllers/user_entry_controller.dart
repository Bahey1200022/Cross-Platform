import 'dart:convert';
import 'package:sarakel/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/Widgets/home/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<bool> usernameExists(String username) async {
    final response =
        await http.get(Uri.parse('$BASE_URL/api/username_available/$username'));

    if (response.statusCode == 200) {
      return false;
    } else {
      return true;
    }
  }

  // signUpUser function sends a POST request to the backend endpoint for user signup
  Future<bool> passToServer(BuildContext context) async {
    var data = {
      "username": usernameScreen,
      "email": emailScreen,
      "password": passwordScreen
    };

    var url = Uri.parse('$BASE_URL/api/signup');

    try {
      var response = await http.post(
        url,
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // User signed up successfully
        // Optionally, you can navigate to the login screen or any other screen

        Navigator.pushNamed(context, '/login');
        return true;
      } else {
        // Signup failed, handle the error
        return false;
      }
    } catch (e) {
      // Handle network errors
      return false;
    }
  }

  ///loginUser function post req to /login endpoint
  Future<bool> loginUser(
      BuildContext context, String email, String password) async {
    var data = {"emailOrUsername": email, "password": password};
    try {
      var response = await http.post(
        Uri.parse('$BASE_URL/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      var jsonData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        prefs = await SharedPreferences.getInstance();
        var token = jsonData['token'];

        prefs!.setString('token', token);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SarakelHomeScreen(
                    homescreenController: HomescreenController(token: token))));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
