// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sarakel/constants.dart';
import 'package:http/http.dart' as http;

void changeEmail(String newEmail, String token, BuildContext context) async {
  var response = await http.patch(Uri.parse('$BASE_URL/api/v1/me/prefs'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': newEmail}));
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email changed successfully')));
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Failed to change email')));
  }
}

bool validateEmail(String email) {
  // Regular expression for email validation
  RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}
