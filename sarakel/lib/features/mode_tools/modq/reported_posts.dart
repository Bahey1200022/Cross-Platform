// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/widgets/post_card.dart';
import 'package:sarakel/features/mode_tools/modq/getfunc.dart';
import 'package:sarakel/models/post.dart';

class ReportedPostsPage extends StatefulWidget {
  String community;
  ReportedPostsPage({super.key, required this.community});

  @override
  State<ReportedPostsPage> createState() => _ReportedPostsPageState();
}

class _ReportedPostsPageState extends State<ReportedPostsPage> {
  List<Post> posts = [];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reported Posts'),
        ),
        body: FutureBuilder<List<Post>>(
          future: getReportedPosts(widget.community),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final posts = snapshot.data ?? [];

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  // Show the post
                  return PostCard(
                    post: post,
                    onHide: () {},
                  );
                },
              );
            }
          },
        ));
  }
}
