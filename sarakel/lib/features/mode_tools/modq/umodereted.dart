import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/widgets/post_card.dart';
import 'package:sarakel/features/mode_tools/modq/getfunc.dart';
import 'package:sarakel/models/post.dart';

class Unmoderated extends StatefulWidget {
  String community;
  Unmoderated({Key? key, required this.community}) : super(key: key);

  @override
  State<Unmoderated> createState() => _UnmoderatedState();
}

class _UnmoderatedState extends State<Unmoderated> {
  List<Post> posts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  void load() async {
    posts = await getUnmoderated(widget.community);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unmoderated'),
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