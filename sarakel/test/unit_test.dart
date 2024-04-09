import 'dart:convert';

import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Test API call for communities', () async {
    // Make the API call
    var response =
        await http.get(Uri.parse('http://192.168.1.10:3000/communities'));

    // Verify the response status code
    expect(response.statusCode, 200);

    var data = json.decode(response.body);
    var item = data[0];
    expect(item["name"], "c/demoooo");
  });

  test('Test API call for user', () async {
    // Make the API call
    var response = await http.get(Uri.parse('http://192.168.1.10:3000/users'));

    // Verify the response status code
    expect(response.statusCode, 200);

    var data = json.decode(response.body);
    var item = data[0];
    expect(item["username"], "u/ty");
  });

  test('Test API call for posts', () async {
    // Make the API call
    var response = await http.get(Uri.parse('http://192.168.1.10:3000/posts'));

    // Verify the response status code
    expect(response.statusCode, 200);

    var data = json.decode(response.body);
    var item = data[0];
    expect(item["content"], "Did you check out the brand new feature!!!!");
  });
}
