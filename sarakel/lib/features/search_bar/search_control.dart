import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:http/http.dart' as http;

///getting the suggestions list from the backend
Future<List<dynamic>> fetchSuggestions(String query) async {
  var response = await http.post(Uri.parse('$BASE_URL/searchBy/All'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'keyword': query,
      }));
  if (response.statusCode != 200) {
    throw Exception('Failed to load suggestions');
  } else {
    var suggestionsList = json.decode(response.body);
    List<dynamic> allResults = suggestionsList['allResults'];
    List<dynamic> allSuggestions = suggestionsList['allSuggestions'];

    List<dynamic> suggestions = [];
    suggestions.addAll(allResults);
    suggestions.addAll(allSuggestions);
    for (var suggestion in suggestions) {
      if (suggestion.containsKey('title')) {
        suggestion['name'] = suggestion['title'];
        suggestion['Type'] = 'Post';
      } else if (suggestion.containsKey('username')) {
        suggestion['name'] = suggestion['username'];
        suggestion['Type'] = 'User';
      } else if (suggestion.containsKey('communityName')) {
        suggestion['name'] = suggestion['communityName'];
        suggestion['Type'] = 'Community';
      }
    }

    return suggestions;
  }
}
