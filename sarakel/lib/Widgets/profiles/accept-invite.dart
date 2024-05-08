// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

///accept invite to be a moderator in community page
void acceptInvite(String community, String token, BuildContext context) async {
  try {
    var response = await http.post(
        Uri.parse('$BASE_URL/r/$community/api/accept_moderator_invite'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        });
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error'),
        ),
      );
    }
  } catch (e) {
    print(e);
  }
}
