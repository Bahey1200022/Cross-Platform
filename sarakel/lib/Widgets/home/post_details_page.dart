import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/post.dart';

class PostDetailsPage extends StatefulWidget {
  final Post post;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  const PostDetailsPage({
    Key? key,
    required this.post,
    required this.onUpvote,
    required this.onDownvote,
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
        title: Text(widget.post.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.post.communityName} • ${widget.post.duration ?? "Recently"}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            SizedBox(height: 10),
            Text(
              widget.post.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            if (widget.post.imagePath != null)
              Image.asset(widget.post.imagePath!),
            SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: Icon(widget.post.isUpvoted
                      ? Icons.arrow_upward
                      : Icons.arrow_upward_outlined),
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
                  icon: Icon(widget.post.isDownvoted
                      ? Icons.arrow_downward
                      : Icons.arrow_downward_outlined),
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
                Spacer(),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: _sharePost,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
