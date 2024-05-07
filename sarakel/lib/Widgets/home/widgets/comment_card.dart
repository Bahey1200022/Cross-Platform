// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, avoid_print, unused_element, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';
import 'package:sarakel/loading_func/loadreplies.dart';
import 'package:sarakel/models/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  final Function(String, String) onReply;

  const CommentCard({super.key, required this.comment, required this.onReply});

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool _isReplying = false;
  TextEditingController _replyController = TextEditingController();
  bool _showReplies = false;
  List<Comment> _replies = [];

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkSavedState();
  }

  void _checkSavedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSaved = prefs.getBool(widget.comment.id) ?? false;
    setState(() {
      widget.comment.isSaved = isSaved;
    });
  }

  void _toggleReplies(String commentId) {
    setState(() {
      _showReplies = !_showReplies;
      if (_showReplies) {
        print('Post ID: ${widget.comment.postID}, Comment ID: $commentId');
        _loadReplies(commentId); // Pass the comment ID to _loadReplies
      } else {
        // Clear replies list when hiding replies
        setState(() {
          _replies.clear();
        });
      }
    });
  }

  void _toggleReply() {
    setState(() {
      _isReplying = !_isReplying;
    });
  }

  void _submitReply() {
    String replyContent = _replyController.text;
    if (replyContent.isNotEmpty) {
      widget.onReply(replyContent, widget.comment.id);
      _replyController.clear();
      _toggleReply();
    }
  }

  Future<void> _loadReplies(String commentId) async {
    try {
      List<Comment> replies =
          await fetchReplies(widget.comment.postID, commentId);
      setState(() {
        _replies = replies;
      });
    } catch (e) {
      print('Failed to load replies: $e');
    }
  }

  void _toggleSave() {
    setState(() {
      widget.comment.isSaved = !widget.comment.isSaved;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                widget.comment.isSaved ? 'Comment saved' : 'Comment unsaved')),
      );
      if (widget.comment.isSaved) {
        _saveComment();
      } else {
        _unSaveComment();
      }
    });
  }

  void _report() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comment reported'),
      ),
    );
  }

  void _blockUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User blocked'),
      ),
    );
  }

  void _saveComment() async {
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
          'type': 'comment',
          'entityId': widget.comment.id,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          widget.comment.isSaved = true; // Mark as saved locally
          prefs.setBool(
              widget.comment.id, true); // Save state in SharedPreferences
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Comment saved")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to save comment")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error saving comment")));
    }
  }

  void _unSaveComment() async {
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
          'type': 'comment',
          'entityId': widget.comment.id,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          widget.comment.isSaved = false; // Mark as unsaved locally
          prefs.remove(
              widget.comment.id); // Remove saved state from SharedPreferences
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Comment unsaved")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to unsave comment")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error unsaving comment")));
    }
  }

  void _toggleUpvote() {
    bool wasUpvoted = widget.comment.isUpvoted; // Store previous state
    setState(() {
      widget.comment.isUpvoted = !widget.comment.isUpvoted;
      if (widget.comment.isUpvoted) {
        if (!widget.comment.isDownvoted) {
          widget.comment.upvote++;
        } else {
          widget.comment.isDownvoted = false;
          widget.comment.downVote--;
          widget.comment.upvote++;
        }
        _makeCommentVote(1); // Make an upvote API call
      } else {
        widget.comment.upvote--;
        _makeCommentVote(wasUpvoted
            ? 0
            : -1); // Revert to neutral if was upvoted, else downvote
      }
    });
  }

  void _toggleDownvote() {
    bool wasDownvoted = widget.comment.isDownvoted; // Store previous state
    setState(() {
      widget.comment.isDownvoted = !widget.comment.isDownvoted;
      if (widget.comment.isDownvoted) {
        if (!widget.comment.isUpvoted) {
          widget.comment.downVote++;
        } else {
          widget.comment.isUpvoted = false;
          widget.comment.upvote--;
          widget.comment.downVote++;
        }
        _makeCommentVote(-1); // Make a downvote API call
      } else {
        widget.comment.downVote--;
        _makeCommentVote(wasDownvoted
            ? 0
            : 1); // Revert to neutral if was downvoted, else upvote
      }
    });
  }

  void _makeCommentVote(int voteType) async {
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
          'type': 'comment',
          'entityId': widget.comment.id,
          'rank': voteType,
        }),
      );
      print(response.body);
    } catch (e) {
      print('Error making comment vote: $e');
    }
  }

  void _reportReply() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reply reported'),
      ),
    );
  }

  void _blockUserReply() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User of the reply blocked'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/avatar_logo.jpeg'),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'u/${widget.comment.userID}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.comment.dateTime,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.comment.content),
            ElevatedButton(
              onPressed: () {
                _toggleReplies(widget.comment.id);
              },
              child: Text(_showReplies ? 'Hide Replies' : 'View Replies'),
            ),
            if (_showReplies)
              Column(
                children: _replies.map((reply) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 16,
                                backgroundImage: AssetImage('assets/avatar_logo.jpeg'),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'u/${reply.userID}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    reply.dateTime,
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(reply.content),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.flag),
                                onPressed: _reportReply,
                              ),
                              IconButton(
                                icon: const Icon(Icons.block),
                                onPressed: _blockUserReply,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    widget.comment.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: widget.comment.isSaved ? Colors.blue : null,
                  ),
                  onPressed: _toggleSave,
                ),
                IconButton(
                  icon: const Icon(Icons.reply),
                  onPressed: _toggleReply,
                ),
                if (_isReplying)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: _replyController,
                        decoration: InputDecoration(
                          hintText: 'Write a reply...',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _submitReply,
                          ),
                        ),
                        onSubmitted: (_) {
                          _submitReply();
                        },
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  color: widget.comment.isUpvoted ? Colors.orange : null,
                  onPressed: _toggleUpvote,
                ),
                Text('${widget.comment.upvote}'),
                IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  color: widget.comment.isDownvoted ? Colors.purple : null,
                  onPressed: _toggleDownvote,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
