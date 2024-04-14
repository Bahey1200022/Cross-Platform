import 'package:flutter/material.dart';

// ignore: must_be_immutable
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
              title: Text('From: $recipient'),
            ),
            ListTile(
              title: Text('To: $sender'),
            ),
            ListTile(
              title: Text(
                ' $title',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              title: Text(' $content'),
            ),
          ],
        ));
  }
}
