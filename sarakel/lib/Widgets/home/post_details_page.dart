import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/post.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:sarakel/Widgets/profiles/fullscreen_image.dart';

class PostDetailsPage extends StatefulWidget {
  final Post post;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onShare;
  final VoidCallback onImageTap;

  const PostDetailsPage({
    Key? key,
    required this.post,
    required this.onUpvote,
    required this.onDownvote,
    required this.onShare,
    required this.onImageTap,
  }) : super(key: key);

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  void _sharePost() {
    String link = "http://192.168.1.10:3000/post/${widget.post.id}";
    Clipboard.setData(ClipboardData(text: link)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Link copied to clipboard!")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('c/${widget.post.communityName}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: sarakelSearch());
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
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
            Text(
              'c/${widget.post.communityName}',
              style:
                  TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 12),
            ),
            SizedBox(height: 7),
            Text(
              'u/${widget.post.username} • ${widget.post.duration ?? "Recently"}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            SizedBox(height: 10),
            Text(
              widget.post.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
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

                child:
                    widget.post.imagePath != null && widget.post.imagePath != ""
                        ? Image.network(widget.post.imagePath!)
                        : Image.asset(
                            'apple.jpg'), // Add default image asset path here
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_upward),
                      color: widget.post.isUpvoted
                          ? Color.fromARGB(255, 255, 152, 0)
                          : Colors.grey,
                      onPressed: () {
                        setState(() {
                          widget.onUpvote();
                        });
                      },
                    ),
                    Text('${widget.post.upVotes}'),
                    IconButton(
                      icon: Icon(Icons.arrow_downward),
                      color: widget.post.isDownvoted
                          ? Color.fromARGB(255, 156, 39, 176)
                          : Colors.grey,
                      onPressed: () {
                        setState(() {
                          widget.onDownvote();
                        });
                      },
                    ),
                    Text('${widget.post.downVotes}'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {},
                    ),
                    Text('${widget.post.comments}'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
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
                  decoration: InputDecoration(
                    hintText: "Add comment...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  // Send the comment
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
