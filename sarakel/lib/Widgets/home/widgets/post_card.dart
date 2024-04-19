import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/explore_communities/join_button.dart';
import 'package:sarakel/Widgets/explore_communities/join_button_controller.dart';
import 'package:sarakel/Widgets/explore_communities/leave_community_controller.dart';
import 'package:sarakel/Widgets/home/post_details_page.dart';
import 'package:sarakel/Widgets/home/widgets/functions.dart';
import 'package:sarakel/Widgets/home/widgets/video_player.dart';
import 'package:sarakel/Widgets/profiles/fullscreen_image.dart';
import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/post.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onHide;

  const PostCard({Key? key, required this.post, required this.onHide})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool hasBeenShared = false;
  bool _isJoined = false;

  void _toggleUpvote() {
    bool wasUpvoted = widget.post.isUpvoted; // Store previous state
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
        _makeVote(1); // Make an upvote API call
      } else {
        widget.post.upVotes--;
        _makeVote(wasUpvoted
            ? 0
            : -1); // Revert to neutral if was upvoted, else downvote
      }
    });
  }

  void _toggleDownvote() {
    bool wasDownvoted = widget.post.isDownvoted; // Store previous state
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
        _makeVote(-1); // Make a downvote API call
      } else {
        widget.post.downVotes--;
        _makeVote(wasDownvoted
            ? 0
            : 1); // Revert to neutral if was downvoted, else upvote
      }
    });
  }

//function to save post to the database
  void _savePost() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var response = await http.post(
        Uri.parse('$BASE_URL/api/save'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'type': 'post',
          'entityId': widget.post.id,
        }),
      );
      print(response.body);
    } catch (e) {
      print('Error saving post: $e');
    }
  }

  void _unSavePost() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var response = await http.post(
        Uri.parse('$BASE_URL/api/unsave'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'type': 'post',
          'entityId': widget.post.id,
        }),
      );
      print(response.body);
    } catch (e) {
      print('Error saving post: $e');
    }
  }

  void _makeVote(int voteType) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var response = await http.post(
        Uri.parse('$BASE_URL/api/vote'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'type': 'post',
          'entityId': widget.post.id,
          'rank': voteType,
        }),
      );
      print(response.body);
    } catch (e) {
      print('Error saving post: $e');
    }
  }

  void _report() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      print(widget.post.username);
      var response = await http.post(
        Uri.parse('$BASE_URL/api/report'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'type': 'user',
          'reason': 'spam',
          'reportedUsername': widget.post.username,
        }),
      );
      print(response.body);
    } catch (e) {
      print('Error saving post: $e');
    }
  }

  void _toggleSave() {
    setState(() {
      widget.post.isSaved = !widget.post.isSaved;
    });
  }

  void _sharePost() {
    if (!hasBeenShared) {
      setState(() {
        widget.post.shares++;
        hasBeenShared = true;
      });
    }
    String link = "http://192.168.1.10:3000/post/${widget.post.id}";
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
            child: Image.asset(imagePath),
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
            builder: (context) => PostDetailsPage(
                post: widget.post,
                onUpvote: _toggleUpvote,
                onDownvote: _toggleDownvote,
                onShare: _sharePost,
                onMakeVote: _makeVote,
                onImageTap: () => _showImage(context, widget.post.imagePath!)),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'c/${widget.post.communityName}',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${widget.post.duration != null ? '• ${widget.post.duration}' : '6h'}',
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Text(
                        '${widget.post.title}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // JoinButton(
                    //   isJoined: _isJoined,
                    //   onPressed: () async {
                    //     SharedPreferences prefs =
                    //         await SharedPreferences.getInstance();
                    //     var token = prefs.getString('token');
                    //     setState(() {
                    //       _isJoined = !_isJoined;
                    //     });
                    //     if (_isJoined) {
                    //       await JoinCommunityController.joinCommunity(
                    //           widget.post.communityName, token!);
                    //     } else {
                    //       // Add logic to leave the community
                    //       await LeaveCommunityController.leaveCommunity(
                    //           widget.post.communityName, token!);
                    //     }
                    //   },
                    // ),
                    PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'save',
                          child: ListTile(
                            leading: Icon(widget.post.isSaved
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
                          value: 'block_account',
                          child: ListTile(
                            leading: Icon(Icons.block),
                            title: Text('Block Account'),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'hide',
                          child: ListTile(
                            leading: Icon(Icons.visibility_off),
                            title: Text('Hide'),
                          ),
                        ),
                      ],
                      onSelected: (String value) {
                        switch (value) {
                          case 'save':
                            _toggleSave();
                            // Handle save action
                            if (widget.post.isSaved) {
                              _unSavePost();
                            } else {
                              _savePost();
                            }
                            break;
                          case 'report':
                            // Handle report action
                            _report();
                            break;
                          case 'block_account':
                            break;
                          case 'hide':
                            widget.onHide();
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
            SizedBox(height: 8),
            Text(
              widget.post.content,
              style: TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            if (widget.post.imagePath != null && widget.post.imagePath != "")
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
            SizedBox(height: 8),
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
                        _toggleUpvote();
                      },
                    ),
                    Text('${widget.post.upVotes}'),
                    IconButton(
                        icon: Icon(Icons.arrow_downward),
                        color: widget.post.isDownvoted
                            ? Color.fromARGB(255, 156, 39, 176)
                            : Colors.grey,
                        onPressed: () {
                          _toggleDownvote();
                        }),
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
            SizedBox(height: 1, child: Container(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
