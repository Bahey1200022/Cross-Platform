// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:http/http.dart' as http;

/// read message function
readMessage(token, id) async {
  print(id);
  var response = await http.post(Uri.parse('$BASE_URL/api/read_message'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: json.encode({'messageId': id}));

  if (response.statusCode == 200) {
    print('Message read');
  } else {
    print('Message not read');
  }
}
