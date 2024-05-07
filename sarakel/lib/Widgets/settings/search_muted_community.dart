import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchBlockedSuggestions(String query) async {
  var response = await http.post(Uri.parse('$BASE_URL/searchBy/users'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'keyword': query,
      }));
  if (response.statusCode != 200) {
    throw Exception('Failed to load suggestions');
  } else {
    print('user prints');
    print(response.body);
    var suggestionsList = json.decode(response.body);
    List<dynamic> allUsersResults = suggestionsList['usersResults'];
    if (suggestionsList.containsKey('username')) {
      suggestionsList['name'] = suggestionsList['username'];
      suggestionsList['Type'] = 'User';
    }
    List<dynamic> filteredSuggestions = suggestionsList
        .where((suggestion) => suggestion.containsKey('Type'))
        .toList();
    return filteredSuggestions;
  }
}
