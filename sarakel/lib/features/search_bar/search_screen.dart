import 'package:flutter/material.dart';
import 'package:sarakel/features/search_bar/search_control.dart';

class sarakelSearch extends SearchDelegate {
  SearchSerkel searchSerkel = SearchSerkel();
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('data');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<String> matchquery = [];

    for (var item in searchSerkel.demo) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchquery.add(item);
      }
    }
    return ListView.builder(
        itemCount: matchquery.length,
        itemBuilder: (context, index) {
          var result = matchquery[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              showResults(context);
            },
          );
        });
  }
}
