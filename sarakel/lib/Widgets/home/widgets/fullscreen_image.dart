import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:sarakel/Widgets/home/post_details_page.dart';
import 'package:sarakel/models/post.dart';
// Make sure to add pinch_zoom package in your pubspec.yaml

class FullScreenImagePage extends StatefulWidget {
  final String imagePath;
  final String communityName;
  final String title;
  final Post post;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onShare;
  final Function(int) onMakeVote;

  const FullScreenImagePage({
    super.key,
    required this.imagePath,
    required this.communityName,
    required this.title,
    required this.post,
    required this.onUpvote,
    required this.onDownvote,
    required this.onShare,
    required this.onMakeVote,
  });

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('${widget.communityName}: ${widget.title}',
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: PinchZoom(
                maxScale: 2.5,
                onZoomStart: () {
                  print('Start zooming');
                },
                onZoomEnd: () {
                  print('Stop zooming');
                },
                child: Image(image: NetworkImage(widget.imagePath)),
              ),
            ),
          ),
          // Buttons for upvote, downvote, comment, and share
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                color: widget.post.isUpvoted
                    ? const Color.fromARGB(255, 255, 152, 0)
                    : Colors.grey,
                onPressed: widget.onUpvote,
              ),
              Text(widget.post.upVotes.toString()),
              IconButton(
                icon: const Icon(Icons.arrow_downward),
                color: widget.post.isDownvoted
                    ? const Color.fromARGB(255, 156, 39, 176)
                    : Colors.grey,
                onPressed: widget.onDownvote,
              ),
              IconButton(
                icon: const Icon(Icons.comment, color: Colors.white),
                onPressed: () {
                  // Navigate to the PostDetailsPage
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PostDetailsPage(
                        post: widget.post,
                        onUpvote: widget.onUpvote,
                        onDownvote: widget.onDownvote,
                        onShare: widget.onShare,
                        onMakeVote: widget.onMakeVote,
                        onImageTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FullScreenImagePage(
                              imagePath: widget.imagePath,
                              communityName: widget.communityName,
                              title: widget.title,
                              post: widget.post,
                              onUpvote: widget.onUpvote,
                              onDownvote: widget.onDownvote,
                              onShare: widget.onShare,
                              onMakeVote: widget.onMakeVote,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: widget.onShare,
              ),
              Text(widget.post.shares.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
