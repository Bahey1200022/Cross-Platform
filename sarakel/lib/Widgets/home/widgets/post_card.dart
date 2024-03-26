import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/profiles/fullscreen_image.dart';
import '../../../models/post.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  void _toggleUpvote() {
    setState(() {
      widget.post.isUpvoted = !widget.post.isUpvoted;
      if (widget.post.isUpvoted) {
        if (!widget.post.isDownvoted) {
          // Increment upvotes only if the post was not downvoted before
          widget.post.upVotes++;
        } else {
          // If downvoted before, decrement downvotes and reset downvote status
          widget.post.isDownvoted = false;
          widget.post.downVotes--;
          widget.post.upVotes++;
        }
      } else {
        // Decrement upvotes if un-upvoting
        widget.post.upVotes--;
      }
    });
  }

  void _toggleDownvote() {
    setState(() {
      widget.post.isDownvoted = !widget.post.isDownvoted;
      if (widget.post.isDownvoted) {
        if (!widget.post.isUpvoted) {
          // Increment downvotes only if the post was not upvoted before
          widget.post.downVotes++;
        } else {
          // If upvoted before, decrement upvotes and reset upvote status
          widget.post.isUpvoted = false;
          widget.post.upVotes--;
          widget.post.downVotes++;
        }
      } else {
        // Decrement downvotes if un-downvoting
        widget.post.downVotes--;
      }
    });
  }

  void _showImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            child: Image.asset(imagePath), // Display the image in a dialog
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the start
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${widget.post.communityName} ${widget.post.duration != null ? '• ${widget.post.duration}' : ''}',
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Join'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.deepOrange),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8), // Add space between the header and content
            Text(widget.post.content,
                style: TextStyle(fontSize: 14)), // Display post content
            SizedBox(height: 8), // Add space for the image
            if (widget.post.imagePath != null) // Conditional image display
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
                child: Image.asset(widget.post.imagePath!),
              ),

            SizedBox(height: 8), // Add space before the bottom row
            // Bottom row (votes, comments, shares) as previously implemented
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_upward),
                      color:
                          widget.post.isUpvoted ? Colors.orange : Colors.grey,
                      onPressed: _toggleUpvote,
                    ),
                    Text('${widget.post.upVotes}'),
                    IconButton(
                      icon: Icon(Icons.arrow_downward),
                      color:
                          widget.post.isDownvoted ? Colors.purple : Colors.grey,
                      onPressed: _toggleDownvote,
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
                      onPressed: () {},
                    ),
                    Text('${widget.post.shares}'),
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
