import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

void message(BuildContext context, String token, String title, String body,
    String recipients) async {
  var data = {"recipient": recipients, "title": title, "content": body};
  var response = await http.post(
    Uri.parse('$BASE_URL/message/compose'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: json.encode(data),
  );
  print(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Message sent')));
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Message not sent')));
  }
}
