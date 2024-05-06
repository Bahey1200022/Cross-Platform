import 'dart:convert';
import 'dart:ffi';

import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<String> getPicUrl(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  var response = await http
      .get(Uri.parse('$BASE_URL/api/user/$username/overview'), headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  });

  if (response.statusCode == 200) {
    var jsondata = jsonDecode(response.body);
    print('ehhhhh');
    return jsondata['profilePicture'];
  } else {
    return '';
  }
}
