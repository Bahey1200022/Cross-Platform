import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart'; // Make sure to add pinch_zoom package in your pubspec.yaml

class FullScreenImagePage extends StatelessWidget {
  final String imagePath;
  final String communityName;
  final String title;
  // You might want to pass additional data necessary for upvote, downvote, etc.

  const FullScreenImagePage({
    Key? key,
    required this.imagePath,
    required this.communityName,
    required this.title,
  }) : super(key: key);

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
        title: Text('$communityName: $title',
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
                child: Image(image: NetworkImage(imagePath)),
              ),
            ),
          ),
          // Buttons for upvote, downvote, comment, and share
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward, color: Colors.white),
                onPressed: () {
                  // Handle upvote
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_downward, color: Colors.white),
                onPressed: () {
                  // Handle downvote
                },
              ),
              IconButton(
                icon: const Icon(Icons.comment, color: Colors.white),
                onPressed: () {
                  // Handle comment
                },
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // Handle share
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
