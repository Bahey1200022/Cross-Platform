import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/Widgets/chatting/chat_card.dart';
import 'package:sarakel/Widgets/inbox/compose.dart';
import 'package:sarakel/constants.dart';
import '../drawers/community_drawer/community_list.dart';
import '../drawers/profile_drawer.dart';
import '../../models/user.dart';
import '../home/widgets/bottom_bar.dart';
import '../home/widgets/app_bar.dart';
import 'package:http/http.dart' as http;

class InboxSection extends StatefulWidget {
  final String token;

  const InboxSection({required this.token});

  @override
  State<InboxSection> createState() => _InboxSectionState();
}

class _InboxSectionState extends State<InboxSection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List messageCard = [];
  List sentmessageCard = [];
  int _selectedIndex = 4;

  Future<void> initiateMessageCard() async {
    // Make an HTTP request to the API
    var response = await http.get(Uri.parse('$BASE_URL/api/message/inbox'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json'
        });

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the response data
      final jsonData = json.decode(response.body);

      // Update the messageCard list with the response data
      setState(() {
        messageCard = jsonData;
      });
    } else {
      // Handle the error case
    }
  }

  Future<void> initiateSentMessageCard() async {
    var response = await http.get(Uri.parse('$BASE_URL/api/message/sent'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json'
        });

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the response data
      final jsonData = json.decode(response.body);

      // Update the messageCard list with the response data
      setState(() {
        sentmessageCard = jsonData;
      });
    } else {
      // Handle the error case
    }
  }

  @override
  void initState() {
    super.initState();
    initiateMessageCard();
    initiateSentMessageCard();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(widget.token);

    return Scaffold(
      key: _scaffoldKey, // Assign key here
      appBar: CustomAppBar(
        title: 'Inbox',
        scaffoldKey: _scaffoldKey, // Pass the GlobalKey to the CustomAppBar
      ),
      drawer: CommunityDrawer(token: widget.token),
      endDrawer: ProfileDrawer(
        user: User(username: jwtdecodedtoken['username'], token: widget.token),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: messageCard.isNotEmpty ? messageCard.length : 0,
            itemBuilder: (context, index) {
              return ButtonCard(
                sender: messageCard[index]['recipient'],
                receiver: messageCard[index]['username'],
                token: widget.token,
                icon: const Icon(Icons.person),
                live: false,
                title: messageCard[index]['title'],
                content: messageCard[index]['content'],
              );
            },
          ),
        ),
        const ListTile(
          title: Text('Sent Messages'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sentmessageCard.isNotEmpty ? sentmessageCard.length : 0,
            itemBuilder: (context, index) {
              return ButtonCard(
                sender: messageCard[index]['recipient'],
                receiver: messageCard[index]['username'],
                token: widget.token,
                icon: const Icon(Icons.person),
                live: false,
                title: messageCard[index]['title'],
                content: messageCard[index]['content'],
              );
            },
          ),
        )
      ]),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          // Add your button click logic here
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Compose(token: widget.token)));
        },
        icon: const Icon(Icons.add),
        label: const Text('New Message'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        token: widget.token,
      ),
    );
  }
}
