// ignore_for_file: must_be_immutable, library_prefixes, non_constant_identifier_names, avoid_print, sort_child_properties_last

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
  final ScrollController _scrollController = ScrollController();

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
    loadPreviousMessages();
    SocketService.instance.socket!.on('newMessage', (data) {
      setState(() {
        messages.add({
          "sender": data['username'],
          "message": data['content'],
          "id": data['_id']
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Chat messages
                ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      messages.length + 1, // Add 1 for the avatar message
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      /// Display avatar message for the receiver
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              child: Image.asset(
                                  'assets/avatar_logo.jpeg'), 
                              radius: 30.0,
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              'u/${widget.receiver}',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    } else {
                      /// Display normal chat message
                      final messageIndex =
                          index - 1; 
                      final bool isSender =
                          messages[messageIndex]['sender'] == widget.sender;
                      return ChatTile(
                        person: messages[messageIndex]['sender'],
                        content: messages[messageIndex]['message'],
                        profilePicture:
                            'assets/avatar_logo.jpeg', 
                        isSender: isSender,
                      );
                    }
                  },
                ),
              ],
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
                            _controller.clear();
                          }
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ),
                    onSubmitted: (value) {
                      sendMessage(value, widget.receiver);
                      setState(() {
                        if (value.isNotEmpty) {
                          _controller.clear();
                        }
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
