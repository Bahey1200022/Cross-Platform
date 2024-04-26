import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

///function that loads the conversations of the user
Future<List> loadConversation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  var response = await http
      .get(Uri.parse('$BASE_URL/api/message/getconverstaions'), headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  });

  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body);
    //print(jsonData[0]['users'][1]);
    List convo = jsonData.map((item) {
      return {
        'id': item['_id'],
        'users': item['users'][1],
      };
    }).toList();
    return convo;
  } else {
    throw Exception('Failed to load conversations');
  }
}
