import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchBlockedSuggestions(String query) async {
  print('fetching suggestions');
  print(query);
  var response = await http.post(Uri.parse('$BASE_URL/searchBy/users'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'keyword': query,
      }));
  print(response.statusCode);
  if (response.statusCode == 200) {
    var suggestionsList = json.decode(response.body);
    var suggestions = suggestionsList['usersResults'];

    List<dynamic> filteredSuggestions = [];
    for (var suggestion in suggestions) {
      filteredSuggestions.add(suggestion['username']);
    }

    print('ahhhh');
    print(filteredSuggestions);
    return filteredSuggestions;
  } else {
    throw Exception('Failed to load suggestions');
  }
}
