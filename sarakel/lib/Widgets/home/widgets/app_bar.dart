import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:sarakel/providers/user_provider.dart';

import '../../../models/user.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState>?
      scaffoldKey; // Accept scaffoldKey as parameter

  const CustomAppBar({
    super.key,
    required this.title,
    this.scaffoldKey, // Mark scaffoldKey as nullable
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder:
        (BuildContext context, UserProvider userProvider, Widget? child) {
      User? user = userProvider.user;

      return AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            scaffoldKey?.currentState!.openDrawer();
            print(user?.email);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: sarakelSearch());
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              scaffoldKey?.currentState!.openEndDrawer();
            },
          ),
        ],
      );
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
