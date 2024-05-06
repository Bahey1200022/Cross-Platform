import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/Widgets/inbox/chat_card.dart';
import 'package:sarakel/Widgets/inbox/compose.dart';
import 'package:sarakel/Widgets/inbox/sent.dart';
import 'package:sarakel/constants.dart';
import '../drawers/community_drawer/community_list.dart';
import '../drawers/profile_drawer.dart';
import '../../models/user.dart';
import '../home/widgets/bottom_bar.dart';
import 'package:http/http.dart' as http;
import '../home/widgets/app_bar.dart';

/// Email message like class where it displays the user's inbox
class InboxSection extends StatefulWidget {
  final String token;

  const InboxSection({Key? key, required this.token}) : super(key: key);

  @override
  State<InboxSection> createState() => _InboxSectionState();
}

class _InboxSectionState extends State<InboxSection>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late TabController _tabController;
  List messageCard = [];
  List sentmessageCard = [];
  final int _selectedIndex = 4;

  Future<void> initiateMessageCard() async {
    // Make an HTTP request to the API
    var response = await http.get(
      Uri.parse('$BASE_URL/api/message/inbox'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json'
      },
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the response data
      final jsonData = json.decode(response.body);
      print(jsonData[0]['_id']);

      // Update the messageCard list with the response data
      setState(() {
        messageCard = jsonData.reversed.toList();
      });
    } else {
      // Handle the error case
    }
  }

  @override
  void initState() {
    super.initState();
    initiateMessageCard();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(widget.token);

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Inbox',
      ),
      drawer: CommunityDrawer(token: widget.token),
      endDrawer: ProfileDrawer(
        user: User(
          username: jwtdecodedtoken['username'],
          token: widget.token,
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Messages'),
              Tab(text: 'Notifications'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Messages Tab
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            messageCard.isNotEmpty ? messageCard.length : 0,
                        itemBuilder: (context, index) {
                          return ButtonCard(
                            sender: messageCard[index]['recipient'],
                            receiver: messageCard[index]['username'],
                            id: messageCard[index]["_id"],
                            token: widget.token,
                            status: messageCard[index]['status'],
                            icon: const Icon(Icons.person),
                            live: false,
                            title: messageCard[index]['title'],
                            content: messageCard[index]['content'],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // Notifications Tab
                const Center(
                  child: Text('Notifications'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton:
          _tabController.index == 0 // Only show for "Messages" tab
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Compose(token: widget.token),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('New Message'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => sent(token: widget.token),
                          ),
                        );
                      },
                      icon: const Icon(Icons.mail),
                      label: const Text('Sent Messages'),
                    ),
                  ],
                )
              : null,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        token: widget.token,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
