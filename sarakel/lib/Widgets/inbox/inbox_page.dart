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
      print(messageCard);
    } else {
      // Handle the error case
      print('Failed to fetch messages: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    initiateMessageCard();
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
      body: ListView.builder(
        itemCount: messageCard.length > 0 ? messageCard.length : 0,
        itemBuilder: (context, index) {
          return ButtonCard(
            sender: messageCard[index]['recipient'],
            receiver: messageCard[index]['username'],
            token: widget.token,
            icon: Icon(Icons.person),
            live: false,
            title: messageCard[index]['title'],
            content: messageCard[index]['content'],
          );
        },
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          // Add your button click logic here
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Compose(token: widget.token)));
        },
        icon: Icon(Icons.add),
        label: Text('Compose Message'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        token: widget.token,
      ),
    );
  }
}
// child: ElevatedButton.icon(
//             onPressed: () {
//               // Add your button click logic here
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => Compose(token: widget.token)));
//             },
//             icon: Icon(Icons.add),
//             label: Text('Compose Message'),
//           ),