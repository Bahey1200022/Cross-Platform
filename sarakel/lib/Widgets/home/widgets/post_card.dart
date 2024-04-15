import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/explore_communities/join_button.dart';
import 'package:sarakel/Widgets/profiles/fullscreen_image.dart';
import '../../../models/post.dart';
import 'package:flutter/services.dart';
import '../../../Widgets/home/post_details_page.dart';
import 'package:http/http.dart' as http; //modified Hafez
import 'dart:convert'; //modified Hafez

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onHide;

  const PostCard({Key? key, required this.post, required this.onHide})
      : super(key: key);

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

  void _toggleSave() {
    setState(() {
      widget.post.isSaved =
          !widget.post.isSaved; // Directly toggle the post's saved state
    });
  }

  void _sharePost() {
    setState(() {
      widget.post.shares++; // Increment the share count
    });
    String link =
        "http://192.168.1.10:3000/post/${widget.post.id}"; // Generate your link
    Clipboard.setData(ClipboardData(text: link)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Link copied to clipboard!")),
      );
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostDetailsPage(post: widget.post),
          ),
        );
      },
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
                    '${widget.post.title} c/${widget.post.communityName} ${widget.post.duration != null ? '• ${widget.post.duration}' : ''}',
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    JoinButton(
                      onPressed: () {
                        // Add your logic here for joining or leaving the community
                      },
                    ),
                    PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'save',
                          child: ListTile(
                            leading: Icon(widget.post.isSaved
                                ? Icons.bookmark
                                : Icons.bookmark_border), // Icon for Save
                            title: Text('Save'),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'report',
                          child: ListTile(
                            leading: Icon(Icons.flag), // Icon for Report
                            title: Text('Report'),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'block_account',
                          child: ListTile(
                            leading:
                                Icon(Icons.block), // Icon for Block Account
                            title: Text('Block Account'),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'hide',
                          child: ListTile(
                            leading:
                                Icon(Icons.visibility_off), // Icon for Hide
                            title: Text('Hide'),
                          ),
                        ),
                      ],
                      onSelected: (String value) {
                        // Handle menu item selection
                        switch (value) {
                          case 'save':
                            _toggleSave();
                            // Handle save action
                            _savePost();
                            break;
                          case 'report':
                            // Handle report action
                            break;
                          case 'block_account':
                            // Handle blocked account action
                            break;
                          case 'hide':
                            widget.onHide();
                            // Handle hide action
                            break;
                          default:
                            break;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8), // Add space between the header and content
            Text(
              widget.post.content,
              style: TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            // Display post content
            SizedBox(height: 8), // Add space for the image
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
                child: Image(image: NetworkImage(widget.post.imagePath!)),
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
                      onPressed: _sharePost,
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

  //Save post function
  void _savePost() async {
    try {
      final String apiUrl = 'http://localhost:3000/savedPosts';

      final Map<String, String> headers = {'Content-Type': 'application/json'};

      final Map<String, dynamic> postData = {
        'title': widget.post.title,
        'content': widget.post.content,
        'communityId': widget.post.communityId,
        'duration': widget.post.duration,
        'upVotes': widget.post.upVotes,
        'downvotes': widget.post.downVotes,
        'comments': widget.post.comments,
        'communityName': widget.post.communityName

        // Include other necessary data
      };

      final String postJson = jsonEncode(postData);

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: postJson,
      );

      if (response.statusCode == 201) {
        print('Post saved successfully');
      } else {
        print('Failed to save post. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error saving post: $e');
    }
  }
}
