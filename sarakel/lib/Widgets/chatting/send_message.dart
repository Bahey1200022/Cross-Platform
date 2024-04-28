import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void sendMessage(String messages, String receivers) async {
  print(messages);
  print(receivers);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.post(Uri.parse('$BASE_URL/api/message/chat'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"recipient": receivers, "content": messages}));
  print(response.body);
  if (response.statusCode == 200) {
    print('message sent');
  } else {
    print('message not sent');
  }
}
