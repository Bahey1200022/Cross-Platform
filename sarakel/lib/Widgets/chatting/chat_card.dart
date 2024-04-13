import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/chatting/one_on_one.dart';

class ButtonCard extends StatelessWidget {
  ButtonCard(
      {required this.sender,
      required this.icon,
      required this.token,
      required this.receiver});
  final String sender;
  Icon icon = Icon(Icons.person);
  final String token;
  final String receiver;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // Add your onTap logic here
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              sender: sender,
              receiver: 'zyad',
              token: token,
            ),
          ),
        );
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
