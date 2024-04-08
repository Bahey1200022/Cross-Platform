import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:sarakel/Widgets/chatting/chat_card.dart';
import 'package:sarakel/models/user.dart';
import '../drawers/community_list.dart';
import '../drawers/profile_drawer.dart';
import '../../providers/user_provider.dart';
import '../home/widgets/app_bar.dart';
import '../home/widgets/bottom_bar.dart';

class ChatSection extends StatefulWidget {
  final token;

  const ChatSection({required this.token});

  @override
  State<ChatSection> createState() => _ChatSection();
}

class _ChatSection extends State<ChatSection> {
  int _selectedIndex = 3;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey(); // Create a GlobalKey

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(widget.token);

    return Scaffold(
        key: _scaffoldKey, // Provide the GlobalKey to the Scaffold

        appBar: CustomAppBar(
          title: 'chat',
          scaffoldKey: _scaffoldKey, // Pass the GlobalKey to the CustomAppBar
        ),
        drawer: CommunityDrawer(),
        endDrawer: ProfileDrawer(
          // Add end drawer
          user: User(username: jwtdecodedtoken['username']),
        ),
        body: const Center(child: Text('hi')),
        bottomNavigationBar:
            CustomBottomNavigationBar(currentIndex: _selectedIndex));
  }
}
