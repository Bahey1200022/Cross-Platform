import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/chatting/one_on_one.dart';
import 'package:sarakel/Widgets/chatting/read_message.dart';
import 'package:sarakel/Widgets/inbox/message_display.dart';

// ignore: must_be_immutable
class ButtonCard extends StatelessWidget {
  ButtonCard(
      {super.key, required this.sender,
      required this.icon,
      required this.token,
      required this.receiver,
      required this.live,
      this.status,
      this.id,
      this.title,
      this.content});
  final String sender;
  Icon icon = const Icon(Icons.person);
  final String token;
  final String receiver;
  final bool live;
  String? title;
  String? content;
  String? id;
  String? status;
  bool getstatus() {
    if (status == 'read') {
      return true;
    } else {
      return false;
    }
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
        // Add your onTap logic here
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
