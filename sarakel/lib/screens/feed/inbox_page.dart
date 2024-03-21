import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/home_screen_controller.dart';
import '../../drawers/community_list.dart';
import '../../drawers/profile_drawer.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../feed/widgets/bottom_bar.dart';
import 'widgets/app_bar.dart';

class InboxSection extends StatefulWidget {
  @override
  State<InboxSection> createState() => _InboxSectionState();
}

class _InboxSectionState extends State<InboxSection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      key: _scaffoldKey, // Assign key here
      appBar: CustomAppBar(
        title: 'Inbox',
        scaffoldKey: _scaffoldKey, // Pass the GlobalKey to the CustomAppBar
      ),
      drawer: CommunityDrawer(),
      endDrawer: ProfileDrawer(
        user: user,
      ),
      body: Center(
        child: Text('Inbox Page is under construction'),
      ),
      bottomNavigationBar:
          CustomBottomNavigationBar(currentIndex: _selectedIndex),
    );
  }
}
