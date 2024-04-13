import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/inbox/service.dart';

class Compose extends StatefulWidget {
  final String token;
  const Compose({required this.token});

  @override
  State<Compose> createState() => _ComposeState();
}

class _ComposeState extends State<Compose> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController recipientController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compose'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: recipientController,
              decoration: InputDecoration(labelText: 'send to ...'),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: bodyController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(labelText: 'Body'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () async {
                String body = bodyController.text.trim();
                String recipients = recipientController.text.trim();
                String title = titleController.text.trim();

                message(context, widget.token, title, body, recipients);
              },
              icon: Icon(Icons.send),
              label: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
