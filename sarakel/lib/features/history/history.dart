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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'recent',
                  child: Text('Recent'),
                ),
                const PopupMenuItem(value: 'upvotes', child: Text('Upvotes')),
                const PopupMenuItem(
                    value: 'downvotes', child: Text('Downvotes')),
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
          ? const Center(child: Text('No posts to show'))
          : ListView.builder(
              itemCount: postsToShow?.length ?? 0,
              itemBuilder: (context, index) {
                final post = postsToShow?[index];

                // Show the post
                return PostCard(
                  post: post!,
                  onHide: () {},
                );
              }),
    );
  }
}
