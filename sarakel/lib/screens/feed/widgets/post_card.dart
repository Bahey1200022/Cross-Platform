import 'package:flutter/material.dart';

import '../../../models/post.dart'; // Import your Post model definition

Widget buildPostCard(Post post) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'r/${post.communityName} ${post.duration != null ? '• ${post.duration}' : ''}',
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Join'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 8), // Add space between the header and content
          Text(post.content,
              style: TextStyle(fontSize: 14)), // Display post content
          SizedBox(height: 8), // Add space before the bottom row
          // Bottom row (votes, comments, shares) as previously implemented
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: () {},
                  ),
                  Text('${post.upVotes}'),
                  IconButton(
                    icon: Icon(Icons.arrow_downward),
                    onPressed: () {},
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {},
                  ),
                  Text('${post.comments}'),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                  ),
                  Text('${post.shares}'),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
