// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/models/post.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sarakel/constants.dart';

class PostService {
  final BuildContext context;

  PostService(this.context);

  Future<void> lockPost(Post post) async {
    await _changeLockStatus(post, true);
  }

  Future<void> unlockPost(Post post) async {
    await _changeLockStatus(post, false);
  }

  Future<void> _changeLockStatus(Post post, bool lock) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Authentication error. Please login again.')),
        );
        return;
      }

      var response = await http.post(
        Uri.parse('$BASE_URL/api/${lock ? 'lock' : 'unlock'}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'Id': post.id}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (lock) {
          post.isLocked = true;
          prefs.setBool(post.id, true);
        } else {
          post.isLocked = false;
          prefs.remove(post.id);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post ${lock ? 'locked' : 'unlocked'}!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to ${lock ? 'lock' : 'unlock'} post: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error ${lock ? 'locking' : 'unlocking'} post: $e')),
      );
    }
  }
}
