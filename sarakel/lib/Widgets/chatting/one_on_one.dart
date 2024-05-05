import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/chatting/card.dart';
import 'package:sarakel/Widgets/chatting/send_message.dart';
import 'package:sarakel/constants.dart';
import 'package:sarakel/socket.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

/// live chat functionality - emitting and receiving messages
class ChatPage extends StatefulWidget {
  final String token;
  final String sender;
  final String receiver;
  String? id;
  ChatPage(
      {super.key,
      required this.receiver,
      required this.sender,
      required this.token,
      this.id});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IO.Socket socket;
  final List messages = [];

  final TextEditingController _controller = TextEditingController();

  void Connect() {
    SocketService.instance.socket!.on("newMessage", (data) {
      print(data);
      messages.add({
        "sender": data["username"],
        "message": data['content'],
        "id": data['_id']
      });
    });
  }

  void MarkOnline() {
    SocketService.instance.socket!.emit('joinConversation', widget.id);
  }

  void loadPreviousMessages() async {
    var response =
        await http.post(Uri.parse('$BASE_URL/api/message/converstaion'),
            headers: {
              'Authorization': 'Bearer ${widget.token}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({"_id": widget.id}));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      jsonData.forEach((element) {
        setState(() {
          messages.add({
            "sender": element['username'],
            "message": element['content'],
            "id": element['_id']
          });
        });
      });
    } else {
      throw Exception('Failed to load conversations');
    }
  }

  @override
  void initState() {
    super.initState();
    //Connect();
    MarkOnline();
    loadPreviousMessages();
    SocketService.instance.socket!.on('newMessage', (data) {
      setState(() {
        messages.add({
          "sender": data['username'],
          "message": data['content'],
          "id": data['_id']
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatTile(
                  person: messages[index]['sender'],
                  content: messages[index]['message'],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      suffixIcon: IconButton(
                          onPressed: () {
                            String value = _controller.text;
                            if (value.isNotEmpty) {
                              sendMessage(value, widget.receiver);
                              // setState(() {
                              //   messages.add({
                              //     'message': value,
                              //     'sender': widget.sender,
                              //   });
                              // });
                              _controller.clear(); // Clear the text field
                            }
                          },
                          icon: const Icon(Icons.send)),
                    ),
                    onSubmitted: (value) {
                      sendMessage(value, widget.receiver);
                      setState(() {
                        if (value.isNotEmpty) {
                          // messages.add({
                          //   'message': value,
                          //   'sender': widget.sender,
                          // });

                          _controller.clear();
                        } // Clear the text field
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
