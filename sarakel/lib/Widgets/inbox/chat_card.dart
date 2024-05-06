// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/chatting/one_on_one.dart';
import 'package:sarakel/Widgets/chatting/read_message.dart';
import 'package:sarakel/Widgets/inbox/message_display.dart';

class ButtonCard extends StatelessWidget {
  const ButtonCard({
    super.key,
    required this.sender,
    required this.icon,
    required this.token,
    required this.receiver,
    required this.live,
    this.status,
    this.id,
    this.title,
    this.content,
    this.sent,
  });

  final String sender;
  final Widget icon; // Change type to Widget to accept any kind of icon
  final String token;
  final String receiver;
  final bool live;
  final String? title;
  final String? content;
  final String? id;
  final String? status;
  final bool? sent;

  bool getstatus() {
    return status == 'read';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        if (live == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                sender: sender,
                receiver: receiver,
                token: token,
                id: id,
              ),
            ),
          );
        } else {
          if (sent == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => inboxMessage(
                  recipient: sender,
                  title: title,
                  content: content,
                  sender: receiver,
                ),
              ),
            );
          } else {
            /////go to see message
            await readMessage(token, id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => inboxMessage(
                  recipient: receiver,
                  title: title,
                  content: content,
                  sender: sender,
                ),
              ),
            );
          }
        }
      },
      leading: CircleAvatar(
        radius: 23,
        child: icon,
      ),
      title: Text(
        receiver,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: getstatus()
          ? const Icon(Icons.check_box)
          : const Icon(Icons.new_label),
    );
  }
}
