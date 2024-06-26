import 'dart:convert';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/Widgets/inbox/chat_card.dart';
import 'package:sarakel/Widgets/inbox/compose.dart';
import 'package:sarakel/Widgets/inbox/sent.dart';
import 'package:sarakel/constants.dart';
import 'package:sarakel/loading_func/loadposts.dart';
import 'package:sarakel/user_profile/get_userpic.dart';
import '../drawers/community_drawer/community_list.dart';
import '../drawers/profile_drawer.dart';
import '../../models/user.dart';
import '../home/widgets/bottom_bar.dart';
import 'package:http/http.dart' as http;
import '../home/widgets/app_bar.dart';

/// Email message like class where it displays the user's inbox
// ignore: must_be_immutable
class InboxSection extends StatefulWidget {
  final String token;
  User user;

  InboxSection({super.key, required this.token, required this.user});

  @override
  State<InboxSection> createState() => _InboxSectionState();
}

class _InboxSectionState extends State<InboxSection>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late TabController _tabController;
  List messageCard = [];
  List notificationCard = [];
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

      // Update the messageCard list with the response data
      setState(() {
        messageCard = jsonData.reversed.toList();
      });
    } else {
      // Handle the error case
    }
  }

  Future<void> initiateNotificationCard() async {
    var response = await http.get(
      Uri.parse('$BASE_URL/api/notifications/listNotifications'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json'
      },
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the response data
      final jsonData = json.decode(response.body);
      var notificationList = jsonData['data'].reversed.toList();
      setState(() {
        notificationCard = notificationList
            .map((item) => {
                  "duration": formatDateTime(item['createdAt']),
                  "content": item['body'],
                })
            .toList();
        // Update the messageCard list with the response data
      });
    } else {
      // Handle the error case
    }
  }

  @override
  void initState() {
    super.initState();
    initiateMessageCard();
    initiateNotificationCard();
    getUserPic();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> getUserPic() async {
    String username = JwtDecoder.decode(widget.token)['username'];
    String picUrl = await getPicUrl(username);
    setState(() {
      widget.user.photoUrl = picUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(widget.token);

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Chat',
        scaffoldKey: _scaffoldKey, // Pass the GlobalKey to the CustomAppBar
        photo: widget.user.photoUrl,
      ),
      drawer: CommunityDrawer(
        token: widget.token,
      ),
      endDrawer: ProfileDrawer(
        // Add end drawer
        user: User(username: jwtdecodedtoken['username'], token: widget.token),
        photo: widget.user.photoUrl,
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
                      child: CustomMaterialIndicator(
                        onRefresh: () async {
                          await initiateMessageCard();
                        },
                        indicatorBuilder: (context, controller) {
                          return Image.asset('assets/logo_2d.png', width: 30);
                        },
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
                    ),
                  ],
                ),

                // Notifications Tab
                Column(
                  children: [
                    Expanded(
                      child: CustomMaterialIndicator(
                        onRefresh: () async {
                          await initiateNotificationCard();
                        },
                        indicatorBuilder: (context, controller) {
                          return Image.asset('assets/logo_2d.png', width: 30);
                        },
                        child: ListView.builder(
                          itemCount: notificationCard.isNotEmpty
                              ? notificationCard.length
                              : 0,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading:
                                  Image.asset('assets/logo_2d.png', width: 30),
                              title: Text(notificationCard[index]['content']),
                              subtitle:
                                  Text(notificationCard[index]['duration']),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )
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
                            builder: (context) =>
                                sent(token: widget.token, user: widget.user),
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
