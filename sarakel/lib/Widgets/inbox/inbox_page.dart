import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/Widgets/inbox/compose.dart';
import '../drawers/community_drawer/community_list.dart';
import '../drawers/profile_drawer.dart';
import '../../models/user.dart';
import '../home/widgets/bottom_bar.dart';
import '../home/widgets/app_bar.dart';

class InboxSection extends StatefulWidget {
  final String token;

  const InboxSection({required this.token});

  @override
  State<InboxSection> createState() => _InboxSectionState();
}

class _InboxSectionState extends State<InboxSection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  int _selectedIndex = 4;

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
      body: Center(
        child: ElevatedButton.icon(
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
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        token: widget.token,
      ),
    );
  }
}
