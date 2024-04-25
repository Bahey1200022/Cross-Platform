import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/Widgets/chatting/conversations.dart';
import 'package:sarakel/Widgets/inbox/chat_card.dart';
import 'package:sarakel/models/user.dart';
import '../drawers/community_drawer/community_list.dart';
import '../drawers/profile_drawer.dart';
import '../home/widgets/app_bar.dart';
import '../home/widgets/bottom_bar.dart';

class ChatSection extends StatefulWidget {
  final String token;

  const ChatSection({required this.token});

  @override
  State<ChatSection> createState() => _ChatSection();
}

class _ChatSection extends State<ChatSection> {
  int _selectedIndex = 3;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey(); // Create a GlobalKey

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(widget.token);
    print(jwtdecodedtoken);
    return Scaffold(
        key: _scaffoldKey, // Provide the GlobalKey to the Scaffold

        appBar: CustomAppBar(
          title: 'chat',
          scaffoldKey: _scaffoldKey, // Pass the GlobalKey to the CustomAppBar
        ),
        drawer: CommunityDrawer(
          token: widget.token,
        ),
        endDrawer: ProfileDrawer(
          // Add end drawer
          user:
              User(username: jwtdecodedtoken['username'], token: widget.token),
        ),
        body: FutureBuilder(
          future: loadConversation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List conversations = snapshot.data as List;
              return ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return ButtonCard(
                    receiver: conversation['users'],
                    icon: const Icon(Icons.person),
                    sender: jwtdecodedtoken['username'],
                    token: widget.token,
                    live: true,
                    id: conversation['id'],
                  );
                },
              );
            }
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          token: widget.token,
        ));
  }
}
