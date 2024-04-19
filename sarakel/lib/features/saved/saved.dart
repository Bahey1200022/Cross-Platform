import 'package:flutter/material.dart';
import 'package:sarakel/models/post.dart';
import 'saved_controller.dart';
import '../../Widgets/home/widgets/post_card.dart';

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final SavedController _savedController = SavedController();
  late Future<List<Post>> _savedPostsFuture;

  @override
  void initState() {
    super.initState();
    _savedPostsFuture = _savedController.fetchSavedPosts();
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
            FutureBuilder<List<Post>>(
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
                          const Divider(),
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No saved posts'));
                }
              },
            ),
            // View for saved comments (placeholder for now)
            const Center(
              child: Text('Saved Comments View'),
            ),
          ],
        ),
      ),
    );
  }
}
