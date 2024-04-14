import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/chatting/one_on_one.dart';
import 'package:sarakel/Widgets/inbox/message_display.dart';

class ButtonCard extends StatelessWidget {
  ButtonCard(
      {required this.sender,
      required this.icon,
      required this.token,
      required this.receiver,
      required this.live,
      this.title,
      this.content});
  final String sender;
  Icon icon = Icon(Icons.person);
  final String token;
  final String receiver;
  final bool live;
  String? title;
  String? content;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (live == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                sender: sender,
                receiver: 'habiba',
                token: token,
              ),
            ),
          );
        } else {
          /////go to see message
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
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
