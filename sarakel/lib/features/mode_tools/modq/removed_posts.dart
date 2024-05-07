import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/widgets/post_card.dart';
import 'package:sarakel/features/mode_tools/modq/getfunc.dart';
import 'package:sarakel/models/post.dart';

class RemovedPostsPage extends StatefulWidget {
  String community;
  RemovedPostsPage({Key? key, required this.community}) : super(key: key);

  @override
  State<RemovedPostsPage> createState() => _RemovedPostsPageState();
}

class _RemovedPostsPageState extends State<RemovedPostsPage> {
  List<Post> posts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // load();
  }

  // void load() async {
  //   posts = await getRemovedPosts(widget.community);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Removed Posts'),
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
