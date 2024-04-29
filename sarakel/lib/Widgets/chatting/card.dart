import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String person;
  final String content;
  const ChatTile({super.key, required this.person, required this.content});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(person),
      subtitle: Text(content),
    );
  }
}
