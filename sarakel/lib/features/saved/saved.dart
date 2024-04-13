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
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Posts'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _savedPostsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // Display both the post title and the PostCard widget
                return Column(
                  children: [
                    // ListTile(
                    //   title: Text(snapshot.data![index].title),
                    //   // Add onTap handler to view full post details if needed
                    // ),
                    PostCard(
                      post: snapshot.data![index],
                      onHide: () {},
                    ), // Display PostCard
                    Divider(), // Add a divider between posts
                  ],
                );
              },
            );
          } else {
            return Center(child: Text('No saved posts'));
          }
        },
      ),
    );
  }
}
