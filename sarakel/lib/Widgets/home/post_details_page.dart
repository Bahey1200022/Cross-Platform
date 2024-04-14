import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/post.dart';

class PostDetailsPage extends StatefulWidget {
  final Post post;

  const PostDetailsPage({Key? key, required this.post}) : super(key: key);

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  void _toggleUpvote() {
    setState(() {
      widget.post.isUpvoted = !widget.post.isUpvoted;
      if (widget.post.isUpvoted) {
        if (!widget.post.isDownvoted) {
          widget.post.upVotes++;
        } else {
          widget.post.isDownvoted = false;
          widget.post.downVotes--;
          widget.post.upVotes++;
        }
      } else {
        widget.post.upVotes--;
      }
    });
  }

  void _toggleDownvote() {
    setState(() {
      widget.post.isDownvoted = !widget.post.isDownvoted;
      if (widget.post.isDownvoted) {
        if (!widget.post.isUpvoted) {
          widget.post.downVotes++;
        } else {
          widget.post.isUpvoted = false;
          widget.post.upVotes--;
          widget.post.downVotes++;
        }
      } else {
        widget.post.downVotes--;
      }
    });
  }

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
                      ? Icons.thumb_up
                      : Icons.thumb_up_alt_outlined),
                  color: widget.post.isUpvoted ? Colors.blue : null,
                  onPressed: _toggleUpvote,
                ),
                Text('${widget.post.upVotes}'),
                IconButton(
                  icon: Icon(widget.post.isDownvoted
                      ? Icons.thumb_down
                      : Icons.thumb_down_alt_outlined),
                  color: widget.post.isDownvoted ? Colors.red : null,
                  onPressed: _toggleDownvote,
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
