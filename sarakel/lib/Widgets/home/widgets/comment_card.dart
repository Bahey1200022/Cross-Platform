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

  const CommentCard({Key? key, required this.comment, required this.onReply})
      : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool _isReplying = false;
  TextEditingController _replyController = TextEditingController();
  bool _showReplies = false;
  bool loggedUserComment = false;

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
    _checkLoginStatus();
  }

  void _checkSavedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSaved = prefs.getBool(widget.comment.id) ?? false;
    setState(() {
      widget.comment.isSaved = isSaved;
    });
  }

  Future<bool> checkLoggedInUserComment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    if (username == widget.comment.userID) {
      return true;
    }
    return false;
  }

  Future<void> _checkLoginStatus() async {
    loggedUserComment = await checkLoggedInUserComment();
  }

  void _toggleReplies(String commentId) {
    setState(() {
      _showReplies = !_showReplies;
      if (_showReplies) {
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
    });
  }

  void _toggleUpvote() {
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
        _makeCommentVote(widget.comment.isDownvoted ? 0 : -1);
      }
    });
  }

  void _toggleDownvote() {
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
        _makeCommentVote(widget.comment.isUpvoted ? 0 : 1);
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
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/avatar_logo.jpeg'),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'u/${widget.comment.userID}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.comment.dateTime,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
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
                  return Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage('assets/avatar_logo.jpeg'),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('u/${reply.userID}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(reply.content),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
<<<<<<< HEAD
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'save':
                        _toggleSave();
                        // Handle save action
                        if (widget.comment.isSaved) {
                          setState(() {
                            _saveComment();
                          });
                          ();
                        } else {
                          setState(() {
                            _unSaveComment();
                          });
                        }
                        break;
                      case 'report':
                        // Implement report functionality
                        setState(() {
                          _report();
                        });

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
                        title: Text(widget.comment.isSaved
                            ? 'Unsave'
                            : 'Save'), // Dynamic text based on saved state
                      ),
                    ),
                    if (!loggedUserComment)
                      const PopupMenuItem<String>(
                        value: 'report',
                        child: ListTile(
                          leading: Icon(Icons.flag),
                          title: Text('Report'),
                        ),
                      ),
                    if (!loggedUserComment)
                      const PopupMenuItem<String>(
                        value: 'block',
                        child: ListTile(
                          leading: Icon(Icons.block),
                          title: Text('Block'),
                        ),
                      ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.reply),
                  onPressed: () {
                    _toggleReply();
                  }, // Implement reply functionality
                ),
                if (_isReplying)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: _replyController,
                        decoration: InputDecoration(
                          hintText: 'Write a reply...',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: _submitReply,
                          ),
                        ),
                        onSubmitted: (_) {
                          _submitReply();
                        },
                      ),
                    ),
                  ),
=======
>>>>>>> a5d412fef3da5ffe555e4ad4de15c618a710e929
                IconButton(
                  icon: Icon(Icons.arrow_upward),
                  color: widget.comment.isUpvoted
                      ? const Color.fromARGB(255, 255, 152, 0)
                      : Colors.grey,
                  onPressed: _toggleUpvote,
                ),
                Text('${widget.comment.upvote}'),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  color: widget.comment.isDownvoted
                      ? const Color.fromARGB(255, 156, 39, 176)
                      : Colors.grey,
                  onPressed: _toggleDownvote,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.reply),
                  onPressed: () {
                    _toggleReply();
                  },
                ),
                if (_isReplying)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        controller: _replyController,
                        decoration: InputDecoration(
                          hintText: 'Write a reply...',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: _submitReply,
                          ),
                        ),
                        onSubmitted: (_) {
                          _submitReply();
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
