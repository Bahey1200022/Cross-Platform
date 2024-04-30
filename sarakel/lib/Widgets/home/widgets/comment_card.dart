import 'package:flutter/material.dart';
import 'package:sarakel/models/comment.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;

  const CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  void _toggleSave() {
    setState(() {
      widget.comment.isSaved = !widget.comment.isSaved;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                widget.comment.isSaved ? 'Comment saved' : 'Comment unsaved')),
      );
    });
  }

  void _upvote() {
    setState(() {
      widget.comment.upvote++;
    });
  }

  void _downvote() {
    setState(() {
      widget.comment.downVote++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.comment.userID,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(' • ${widget.comment.duration}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
            SizedBox(height: 5),
            Text(widget.comment.content),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.reply),
                      onPressed: () {}, // Implement reply functionality
                    ),
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: _upvote,
                    ),
                    Text('${widget.comment.upvote}'),
                    IconButton(
                      icon: Icon(Icons.thumb_down),
                      onPressed: _downvote,
                    ),
                    Text('${widget.comment.downVote}'),
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'save':
                        _toggleSave();
                        break;
                      case 'report':
                        // Implement report functionality
                        break;
                      case 'block':
                        // Implement block functionality
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'save',
                      child: ListTile(
                        leading: Icon(widget.comment.isSaved
                            ? Icons.bookmark
                            : Icons.bookmark_border),
                        title: Text('Save'),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'report',
                      child: ListTile(
                        leading: Icon(Icons.flag),
                        title: Text('Report'),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'block',
                      child: ListTile(
                        leading: Icon(Icons.block),
                        title: Text('Block'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
