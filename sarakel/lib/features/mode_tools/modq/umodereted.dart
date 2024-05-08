// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/widgets/post_card.dart';
import 'package:sarakel/Widgets/profiles/communityposts.dart';
import 'package:sarakel/features/mode_tools/modq/post_moderation.dart';
import 'package:sarakel/models/post.dart';

class Unmoderated extends StatefulWidget {
  String community;
  Unmoderated({super.key, required this.community});

  @override
  State<Unmoderated> createState() => _UnmoderatedState();
}

class _UnmoderatedState extends State<Unmoderated> {
  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    posts = fetchCommunityPosts(widget.community);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unmoderated'),
      ),
      body: FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        // Add your on tap logic here
                        approveOrRemove(snapshot.data![index].id, context,
                            snapshot.data![index].communityName);
                      },
                      child: PostCard(
                        post: snapshot.data![index],
                        onHide: () {
                          // Add your on hold logic here
                        },
                      ),
                    ),
                    // const Divider(),
                  ],
                );
              },
            );
          } else {
            return const Center(child: Text('No community posts'));
          }
        },
      ),
    );
  }
}
