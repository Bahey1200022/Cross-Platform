import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sarakel/models/comment.dart';
import 'package:sarakel/models/post.dart';
import 'saved_controller.dart';
import '../../Widgets/home/widgets/post_card.dart';
import '../../Widgets/home/widgets/comment_card.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final SavedPostsController _savedController = SavedPostsController();
  final SavedCommentsController _savedCommentsController =
      SavedCommentsController();
  late Future<List<Post>> _savedPostsFuture;
  late Future<List<Comment>> _savedCommentsFuture;

  @override
  void initState() {
    super.initState();
    _savedPostsFuture = _savedController.fetchSavedPosts();
    _savedCommentsFuture = _savedCommentsController.fetchSavedComments();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs (posts and comments)
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Saved'),
          bottom: const TabBar(
            labelStyle: TextStyle(color: Colors.black),
            tabs: [
              Tab(text: 'Posts'), // Tab for saved posts
              Tab(text: 'Comments'), // Tab for saved comments
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // View for saved posts
            CustomMaterialIndicator(
              onRefresh: () async {
                setState(() {
                  _savedPostsFuture = _savedController.fetchSavedPosts();
                });
              },
              indicatorBuilder: (context, controller) {
                return Image.asset('assets/logo_2d.png', width: 30);
              },
              child: FutureBuilder<List<Post>>(
                future: _savedPostsFuture,
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
                            PostCard(
                              post: snapshot.data![index],
                              onHide: () {},
                            ),
                            // const Divider(),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No saved posts'));
                  }
                },
              ),
            ),
            // View for saved comments (placeholder for now)
            CustomMaterialIndicator(
              onRefresh: () async {
                setState(() {
                  _savedCommentsFuture =
                      _savedCommentsController.fetchSavedComments();
                });
              },
              indicatorBuilder: (context, controller) {
                return Image.asset('assets/logo_2d.png', width: 30);
              },
              child: FutureBuilder<List<Comment>>(
                future: _savedCommentsFuture,
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
                            CommentCard(
                              // Assuming you have a CommentCard widget

                              comment: snapshot.data![index],
                              onReply: (String param1, String param2) {},
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No saved comments'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
