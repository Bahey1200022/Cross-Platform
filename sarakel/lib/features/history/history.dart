import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/widgets/post_card.dart';
import 'package:sarakel/features/history/history_controller.dart';

import '../../models/post.dart';

class History extends StatefulWidget {
  final String token;
  const History({super.key, required this.token});

  @override
  State<History> createState() => _HistroyState();
}

class _HistroyState extends State<History> {
  String _selectedPage = 'recent';
  List<Post>? postsToShow;
  @override
  void initState() {
    super.initState();
    loadRecentHistory().then((posts) {
      setState(() => postsToShow = posts);
    });
    loadDownvotedHistory().then((posts) {
      setState(() => postsToShow = posts);
    });
    loadUpvotedHistory().then((posts) {
      setState(() => postsToShow = posts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'recent',
                  child: Text(
                    'Recent',
                    style: TextStyle(
                        fontWeight: _selectedPage == 'recent'
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                ),
                PopupMenuItem(
                  value: 'upvotes',
                  child: Text(
                    'Upvotes',
                    style: TextStyle(
                        fontWeight: _selectedPage == 'upvotes'
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                ),
                PopupMenuItem(
                  value: 'downvotes',
                  child: Text(
                    'Downvotes',
                    style: TextStyle(
                        fontWeight: _selectedPage == 'downvotes'
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'recent') {
                loadRecentHistory().then((posts) {
                  setState(() {
                    _selectedPage = value;
                    postsToShow = posts;
                  });
                });
              }
              if (value == 'upvotes') {
                setState(() {
                  postsToShow = null;
                });
                loadUpvotedHistory().then((posts) {
                  ///to be changed later
                  setState(() {
                    _selectedPage = value;
                    postsToShow = posts;
                  });
                });
              }
              if (value == 'downvotes') {
                loadDownvotedHistory().then((posts) {
                  ///to be changed later
                  setState(() {
                    _selectedPage = value;
                    postsToShow = posts;
                  });
                });
              }
            },
            icon: const Icon(Icons.filter_list_alt),
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'option1',
                  child: Text('Clear History'),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'option1') {
                if (_selectedPage == 'recent') {
                  setState(() {
                    postsToShow = null;
                  });
                }
              }
            },
          ),
        ],
      ),
      body: postsToShow == null
          ? Center(child: Image.asset('assets/logo_2d.png', width: 30))
          : CustomMaterialIndicator(
              onRefresh: () async {
                if (_selectedPage == 'recent') {
                  final posts = await loadRecentHistory();
                  setState(() => postsToShow = posts);
                } else if (_selectedPage == 'upvotes') {
                  final posts = await loadUpvotedHistory();
                  setState(() => postsToShow = posts);
                } else if (_selectedPage == 'downvotes') {
                  final posts = await loadDownvotedHistory();
                  setState(() => postsToShow = posts);
                }
              },
              indicatorBuilder: (context, controller) {
                return Image.asset('assets/logo_2d.png', width: 30);
              },
              child: ListView.builder(
                  itemCount: postsToShow?.length ?? 0,
                  itemBuilder: (context, index) {
                    final post = postsToShow?[index];

                    // Show the post
                    return PostCard(
                      post: post!,
                      onHide: () {},
                    );
                  }),
            ),
    );
  }
}
