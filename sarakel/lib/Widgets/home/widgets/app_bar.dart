// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:sarakel/providers/user_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  String? photo;
  final GlobalKey<ScaffoldState>?
      scaffoldKey; // Accept scaffoldKey as parameter

  CustomAppBar({
    super.key,
    required this.title,
    required this.photo,
    this.scaffoldKey, // Mark scaffoldKey as nullable
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder:
        (BuildContext context, UserProvider userProvider, Widget? child) {
      return AppBar(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
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
            icon: Stack(
              children: [
                Image.network(photo ?? 'assets/logo_2d.png'),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
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
