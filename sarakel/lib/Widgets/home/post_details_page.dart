import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/Widgets/home/widgets/category.dart';
import 'package:sarakel/Widgets/home/widgets/comment_card.dart';
import 'package:sarakel/Widgets/home/widgets/functions.dart';
import 'package:sarakel/Widgets/home/widgets/nsfw.dart';
import 'package:sarakel/Widgets/home/widgets/video_player.dart';
import 'package:sarakel/constants.dart';
import 'package:sarakel/loadcomments.dart';
import 'package:sarakel/models/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/post.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:sarakel/Widgets/home/widgets/fullscreen_image.dart';

///full screen post details page and adding a comment on the post feature
class PostDetailsPage extends StatefulWidget {
  final Post post;

  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onShare;
  final VoidCallback onImageTap;
  final Function(int) onMakeVote;
  const PostDetailsPage({
    super.key,
    required this.post,
    required this.onUpvote,
    required this.onDownvote,
    required this.onShare,
    required this.onImageTap,
    required this.onMakeVote,
  });

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final TextEditingController _commentController =
      TextEditingController(); // Add controller
  List<Comment> comments = [];
  bool isLoading = true;

  @override
  void dispose() {
    _commentController.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadComments();
    //decodeJwt();
  }

  Future<void> _loadComments() async {
    try {
      List<Comment> loadedComments = await fetchComments(widget.post.id);
      if (loadedComments.isNotEmpty) {
        setState(() {
          comments = loadedComments;
          isLoading = false;
        });
      } else {
        // Handling no comments case
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No comments available.'),
          backgroundColor: Colors.blue,
        ));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load comments: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _sharePost() {
    String link = "http://192.168.1.10:3000/post/${widget.post.id}";
    Clipboard.setData(ClipboardData(text: link)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Link copied to clipboard!")),
      );
    });
  }

  Future<void> sendComment(String postID, String content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    Map<String, String> commentData = {
      'content': content,
      'postID': postID,
      //'parentId': "0",
      //'isLocked': "false",
      //'numViews': "0"
    };
    String postJson = jsonEncode(commentData);
    http.Response response = await http.post(
      Uri.parse('$BASE_URL/api/comment'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: postJson,
    );
    //Comment added successfully to post 662bec333d7b7510d8d7bbe7 with content: huiii
    if (response.statusCode == 201 || response.statusCode == 200) {
      print(
          'Comment added successfully to post $postID with content: $content');
    } else {
      print('Failed to add comment. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: sarakelSearch());
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              final GlobalKey<ScaffoldState> scaffoldKey =
                  GlobalKey<ScaffoldState>();

              scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 10,
                  backgroundImage: NetworkImage(
                      "https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0"),
                ),
                const SizedBox(width: 5),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'c/${widget.post.communityName}',
                    style: const TextStyle(
                        //color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'u/${widget.post.username} • ${widget.post.duration ?? "Recently"}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ])
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NSFWButton(isNSFW: widget.post.isNSFW!),
                const SizedBox(width: 5),
                PostCategory(category: widget.post.postCategory),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.post.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (widget.post.imagePath != null &&
                widget.post.imagePath != "") // Conditional image display
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FullScreenImagePage(
                        imagePath: widget.post.imagePath!,
                        communityName: widget.post.communityName,
                        title: widget.post.title,
                      ),
                    ),
                  );
                },
                child: Center(
                  child: widget.post.imagePath != null &&
                          widget.post.imagePath != ""
                      ? isVideo(widget.post.imagePath!)
                          ? VideoPlayerWidget(videoLink: widget.post.imagePath!)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(widget.post.imagePath!),
                            )
                      : Image.asset('assets/apple.jpg'),
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      color: widget.post.isUpvoted
                          ? const Color.fromARGB(255, 255, 152, 0)
                          : Colors.grey,
                      onPressed: () {
                        setState(() {
                          widget.onUpvote();
                        });
                      },
                    ),
                    Text('${widget.post.upVotes}'),
                    IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      color: widget.post.isDownvoted
                          ? const Color.fromARGB(255, 156, 39, 176)
                          : Colors.grey,
                      onPressed: () {
                        setState(() {
                          widget.onDownvote();
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {},
                    ),
                    Text('${widget.post.comments}'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        setState(() {
                          widget.onShare();
                        });
                      },
                    ),
                    Text('${widget.post.shares}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // Important to nest inside SingleChildScrollView
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentCard(comment: comments[index]);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: "Add comment...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // Send the comment
                  String content = _commentController.text;
                  String postID = widget.post.id;
                  sendComment(postID, content);
                  _commentController.clear();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
