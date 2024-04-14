import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/chatting/card.dart';
import 'package:sarakel/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  final String token;
  final String sender;
  final String receiver;

  const ChatPage(
      {required this.receiver, required this.sender, required this.token});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IO.Socket socket;
  final List messages = [];

  final TextEditingController _controller = TextEditingController();

  void Connect() {
    socket = IO.io('$SOCKET_URL', <String, dynamic>{
      "transports": ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((data) {
      print('Connected');
    });
    socket.emit("/signin", widget.sender);
    socket.on("/chat", (data) {
      print(data);
      messages.add({"sender": data["receiver"], "message": data['message']});
    });
  }

  void sendMessage(String messages, String senders, String receivers) {
    print(messages);
    print(senders);
    print(receivers);
    socket.emit("/chat",
        {"message": messages, "sender": senders, "receiver": receivers});
  }

  @override
  void initState() {
    Connect();
    super.initState();
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
                              sendMessage(
                                  value, widget.sender, widget.receiver);
                              setState(() {
                                messages.add({
                                  'message': value,
                                  'sender': widget.sender,
                                });
                              });
                              _controller.clear(); // Clear the text field
                            }
                          },
                          icon: const Icon(Icons.send)),
                    ),
                    onSubmitted: (value) {
                      sendMessage(value, widget.sender, widget.receiver);
                      setState(() {
                        if (value.isNotEmpty) {
                          messages.add({
                            'message': value,
                            'sender': widget.sender,
                          });

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
