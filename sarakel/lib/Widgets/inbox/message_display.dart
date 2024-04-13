import 'package:flutter/material.dart';

class inboxMessage extends StatelessWidget {
  final String recipient;
  String? title;
  String? content;
  final String sender;
  inboxMessage({
    required this.recipient,
    this.title,
    this.content,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Message'),
        ),
        body: Column(
          children: [
            ListTile(
              title: Text('From: $sender'),
            ),
            ListTile(
              title: Text('To: $recipient'),
            ),
            ListTile(
              title: Text('Title: $title'),
            ),
            ListTile(
              title: Text('Content: $content'),
            ),
          ],
        ));
  }
}
