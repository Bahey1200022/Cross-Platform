// ignore_for_file: must_be_immutable, library_prefixes, non_constant_identifier_names, avoid_print, sort_child_properties_last

import 'dart:convert';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/Widgets/chatting/card.dart';
import 'package:sarakel/Widgets/chatting/send_message.dart';
import 'package:sarakel/constants.dart';
import 'package:sarakel/socket.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

/// live chat functionality - emitting and receiving messages via websockets
/// api call to trigger socket and listen for new messages
// ignore: duplicate_ignore
// ignore: must_be_immutable
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

  void MarkOnline() {
    if (SocketService.instance.socket == null) {
      Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(widget.token);
      var user = jwtdecodedtoken['username'];

      SocketService.instance.connect(BASE_URL, user);
    }
    SocketService.instance.socket!.emit('markOnline', widget.id);
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
    MarkOnline();
    loadPreviousMessages();
    SocketService.instance.socket!.on('newMessage', (data) {
      if (mounted) {
        setState(() {
          messages.add({
            "sender": data['username'],
            "message": data['content'],
            "id": data['_id']
          });
        });
      }
    });
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
                CustomMaterialIndicator(
                  onRefresh: () async {
                    loadPreviousMessages();
                  },
                  indicatorBuilder: (context, controller) {
                    return Image.asset('assets/logo_2d.png', width: 30);
                  },
                  child: ListView.builder(
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
                                child: Image.asset('assets/avatar_logo.jpeg'),
                                radius: 30.0,
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                'u/${widget.receiver}',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      } else {
                        /// Display normal chat message
                        final messageIndex = index - 1;
                        final bool isSender =
                            messages[messageIndex]['sender'] == widget.sender;
                        return ChatTile(
                          person: messages[messageIndex]['sender'],
                          content: messages[messageIndex]['message'],
                          profilePicture: 'assets/avatar_logo.jpeg',
                          isSender: isSender,
                        );
                      }
                    },
                  ),
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
