import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sarakel/constants.dart';
import 'package:sarakel/models/reply.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReplyCard extends StatefulWidget {
  final Reply reply;
  final Function() onReplyModeActivated;

  const ReplyCard(
      {Key? key, required this.reply, required this.onReplyModeActivated})
      : super(key: key);

  @override
  _ReplyCardState createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  void _toggleSave() {
    setState(() {
      widget.reply.isSaved = !widget.reply.isSaved;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(widget.reply.isSaved ? 'reply saved' : 'reply unsaved')),
      );
    });
  }

  void _toggleUpvote() {
    bool wasUpvoted = widget.reply.isUpvoted; // Store previous state
    setState(() {
      widget.reply.isUpvoted = !widget.reply.isUpvoted;
      if (widget.reply.isUpvoted) {
        if (!widget.reply.isDownvoted) {
          widget.reply.upvote++;
        } else {
          widget.reply.isDownvoted = false;
          widget.reply.downVote--;
          widget.reply.upvote++;
        }
        _makereplyVote(1); // Make an upvote API call
      } else {
        widget.reply.upvote--;
        _makereplyVote(wasUpvoted
            ? 0
            : -1); // Revert to neutral if was upvoted, else downvote
      }
    });
  }

  void _toggleDownvote() {
    bool wasDownvoted = widget.reply.isDownvoted; // Store previous state
    setState(() {
      widget.reply.isDownvoted = !widget.reply.isDownvoted;
      if (widget.reply.isDownvoted) {
        if (!widget.reply.isUpvoted) {
          widget.reply.downVote++;
        } else {
          widget.reply.isUpvoted = false;
          widget.reply.upvote--;
          widget.reply.downVote++;
        }
        _makereplyVote(-1); // Make a downvote API call
      } else {
        widget.reply.downVote--;
        _makereplyVote(wasDownvoted
            ? 0
            : 1); // Revert to neutral if was downvoted, else upvote
      }
    });
  }

  void _makereplyVote(int voteType) async {
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
          'type': 'reply',
          'entityId': widget.reply.id,
          'rank': voteType,
        }),
      );
      print(response.body);
    } catch (e) {}
  }

  void _savereply() async {
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
          'type': 'reply',
          'entityId': widget.reply.id,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Adjust based on your API response
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("reply saved")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to save reply")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error saving reply")));
    }
  }

  void _unSavereply() async {
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
          'type': 'reply',
          'entityId': widget.reply.id,
        }),
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Adjust based on your API response
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("reply unsaved")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to unsave reply")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error unsaving reply")));
    }
  }

  void _report() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var response = await http.post(
        Uri.parse('$BASE_URL/api/report'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'type': 'user',
          'reason': 'spam',
          'reportedUsername': widget.reply.userID,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Adjust based on your API response
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Thank you for reporting! We will review it soon.')));
      }
    } catch (e) {}
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
                Text(widget.reply.userID,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(' • ${widget.reply.dateTime}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
            SizedBox(height: 5),
            Text(widget.reply.content),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'save':
                        _toggleSave();
                        // Handle save action
                        if (widget.reply.isSaved) {
                          setState(() {
                            _savereply();
                          });
                          ();
                        } else {
                          setState(() {
                            _unSavereply();
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
                        leading: Icon(widget.reply.isSaved
                            ? Icons.bookmark
                            : Icons.bookmark_border),
                        title: Text(widget.reply.isSaved
                            ? 'Unsave'
                            : 'Save'), // Dynamic text based on saved state
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
                IconButton(
                  icon: Icon(Icons.reply),
                  onPressed: widget.onReplyModeActivated != null
                      ? () {
                          widget.onReplyModeActivated();
                          print('reply id ${widget.reply.id}');
                        }
                      : null,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_upward),
                  color: widget.reply.isUpvoted
                      ? const Color.fromARGB(255, 255, 152, 0)
                      : Colors.grey,
                  onPressed: _toggleUpvote,
                ),
                Text('${widget.reply.upvote}'),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  color: widget.reply.isDownvoted
                      ? const Color.fromARGB(255, 156, 39, 176)
                      : Colors.grey,
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
