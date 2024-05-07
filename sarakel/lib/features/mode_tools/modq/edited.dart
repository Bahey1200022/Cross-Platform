import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/widgets/post_card.dart';
import 'package:sarakel/features/mode_tools/modq/getfunc.dart';
import 'package:sarakel/models/post.dart';

class Edited extends StatefulWidget {
  String community;
  Edited({super.key, required this.community});

  @override
  State<Edited> createState() => _EditedState();
}

class _EditedState extends State<Edited> {
  List<Post> posts = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  void load() async {
    posts = await getEdited(widget.community);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edited'),
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
