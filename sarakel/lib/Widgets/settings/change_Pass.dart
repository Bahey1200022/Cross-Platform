// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

void changePassword(
    BuildContext context, String pass, String token, String oldpass) async {
  var response = await http.patch(Uri.parse('$BASE_URL/api/v1/me/prefs'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'oldPassword': oldpass,
        'password': pass,
      }));

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')));
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to change password')));
  }
}
