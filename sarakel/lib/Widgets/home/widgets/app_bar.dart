import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:sarakel/providers/user_provider.dart';

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
      return AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            scaffoldKey?.currentState!.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: sarakelSearch());
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              scaffoldKey?.currentState!.openEndDrawer();
            },
          ),
        ],
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
