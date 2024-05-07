import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/widgets/post_card.dart';
import 'package:sarakel/features/mode_tools/Reported_posts_controller.dart';
import 'package:sarakel/models/post.dart';

class ReportedPostsPage extends StatefulWidget {
  String community;
  ReportedPostsPage({Key? key, required this.community}) : super(key: key);

  @override
  State<ReportedPostsPage> createState() => _ReportedPostsPageState();
}

class _ReportedPostsPageState extends State<ReportedPostsPage> {
  List<Post> posts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  void load() async {
    posts = await getReportedPosts(widget.community);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reported Posts'),
      ),
      body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];

            // Show the post
            return PostCard(
              post: post,
              onHide: () {},
            );
          }),
    );
  }
}
