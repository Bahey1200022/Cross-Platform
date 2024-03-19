import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sarakel/models/user.dart';
import 'package:http/http.dart' as http;

class UserController {
  String? usernameScreen;
  String emailScreen;
  String passwordScreen;
  UserController(
      {this.usernameScreen,
      required this.emailScreen,
      required this.passwordScreen});

  User setStateUser() {
    return User(email: emailScreen, password: passwordScreen);
  }

  Future<bool> userExists(String email, String password) async {
    final response =
        await http.get(Uri.parse('http://192.168.1.17:3000/users'));

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
    final response =
        await http.get(Uri.parse('http://192.168.1.17:3000/users'));

    if (response.statusCode == 200) {
      // Decode the response body from JSON
      final dynamic users = json.decode(response.body);
      // Iterate through the list of users
      for (var user in users) {
        // Check if the provided username matches any existing username
        if (user['username'] == username) {
          return true; // Username exists
        }
      }
      return false; // Username doesn't exist
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void passToServer(BuildContext context) async {
    var data = {
      "email": emailScreen,
      "password": passwordScreen,
      "token": "true",
      "username": usernameScreen
    };
    var url = Uri.parse('http://192.168.1.17:3000/users');

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
}
