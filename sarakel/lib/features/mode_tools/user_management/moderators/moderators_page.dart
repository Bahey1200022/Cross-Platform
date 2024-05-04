import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/user_management/moderators/add_moderators_page.dart';
import 'package:sarakel/features/mode_tools/user_management/moderators/moderators_search_page.dart';

class ModeratorsPage extends StatefulWidget {
  @override
  _ModeratorsPageState createState() => _ModeratorsPageState();
}

class _ModeratorsPageState extends State<ModeratorsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'Moderators',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ModeratorSearchPage()));
            },
          ),
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddModeratorPage()));
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All'), // Tab for "All"
            Tab(text: 'Editable'), // Tab for "Editable"
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Content for "All" tab
          Container(
            child: Center(
              child: Text('All Moderators'),
            ),
          ),
          // Content for "Editable" tab
          Container(
            child: Center(
              child: Text('Editable Moderators'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
