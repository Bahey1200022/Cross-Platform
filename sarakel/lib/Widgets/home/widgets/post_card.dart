// ignore_for_file: empty_catches, unused_local_variable

import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/controllers/view_post.dart';

import 'package:sarakel/Widgets/home/post_details_page.dart';
import 'package:sarakel/Widgets/home/widgets/category.dart';
import 'package:sarakel/Widgets/home/widgets/functions.dart';
import 'package:sarakel/Widgets/home/widgets/nsfw.dart';
import 'package:sarakel/Widgets/home/widgets/video_player.dart';
import 'package:sarakel/Widgets/home/widgets/fullscreen_image.dart';
import 'package:sarakel/constants.dart';
import 'package:sarakel/features/create_post/edit_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/post.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui' as ui;

/// all post cards functionality features
class PostCard extends StatefulWidget {
  final Post post;
  bool? saved;
  bool? upvoted;
  bool? downvoted;
  final VoidCallback onHide;

  PostCard(
      {super.key,
      required this.post,
      required this.onHide,
      this.saved,
      this.upvoted,
      this.downvoted});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool hasBeenShared = false;
  bool _isBlurred = true;
  bool _isImagePresent() =>
      widget.post.imagePath != null && widget.post.imagePath!.isNotEmpty;
  bool loggedUserPost = false;
  //bool _isJoined = false;
  @override
  void initState() {
    super.initState();
    _checkSavedState();
    _checkLoginStatus();
    // _checkVoteState();
  }

  // void _checkVoteState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> upvotedIds =
  //       json.decode(prefs.getString('upvotedPosts') ?? '[]');
  //   List<String> downvotedIds =
  //       json.decode(prefs.getString('downvotedPosts') ?? '[]');

  //   setState(() {
  //     widget.post.isUpvoted = upvotedIds.contains(widget.post.id);
  //     widget.post.isDownvoted = downvotedIds.contains(widget.post.id);
  //   });
  // }

  void _checkSavedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSaved = prefs.getBool(widget.post.id);
    setState(() {
      widget.post.isSaved = isSaved ?? false;
    });
  }

  Future<bool> checkLoggedInUserPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    if (username == widget.post.username) {
      return true;
    }
    return false;
  }

  Future<void> _checkLoginStatus() async {
    loggedUserPost = await checkLoggedInUserPost();
  }

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
        _makeVote(1); // API call to register upvote
      } else {
        widget.post.upVotes--;
        _makeVote(wasUpvoted
            ? 0
            : -1); // API call to revert vote if previously upvoted
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

        _makeVote(-1); // API call to register downvote
      } else {
        widget.post.downVotes--;

        _makeVote(wasDownvoted
            ? 0
            : 1); // API call to revert vote if previously downvoted
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          widget.post.isSaved = true;
          prefs.setBool(widget.post.id, true); // Persist saved state locally
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Post saved")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to save post")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error saving post")));
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          widget.post.isSaved = false;
          prefs.remove(
              widget.post.id); // Remove saved state from SharedPreferences
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Post unsaved")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to unsave post")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error unsaving post")));
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
    } catch (e) {}
  }

  void _blockAccount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var response = await http.post(
        Uri.parse('$BASE_URL/api/block_user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'usernameToBlock': widget.post.username,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Adjust based on your API response
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('User blocked! You will no longer see their posts.')));
      }
    } catch (e) {}
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
          'reportedUsername': widget.post.username,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Adjust based on your API response
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Thank you for reporting! We will review it soon.')));
      }
    } catch (e) {}
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
        const SnackBar(content: Text("Link copied to clipboard!")),
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

  void _toggleBlur() {
    setState(() {
      _isBlurred = !_isBlurred;
    });
  }

  // Future<void> fetchAndStoreVotedPosts(String username) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   try {
  //     var token = prefs.getString('token');
  //     var upvoteResponse = await http.get(
  //       Uri.parse('$BASE_URL/api/user/$username/upvotedids'),
  //       headers: {'Authorization': 'Bearer $token'},
  //     );
  //     var downvoteResponse = await http.get(
  //       Uri.parse('$BASE_URL/api/user/$username/downvotedids'),
  //       headers: {'Authorization': 'Bearer $token'},
  //     );

  //     if (upvoteResponse.statusCode == 200 &&
  //         downvoteResponse.statusCode == 200) {
  //       List<String> upvotedIds =
  //           List<String>.from(json.decode(upvoteResponse.body));
  //       List<String> downvotedIds =
  //           List<String>.from(json.decode(downvoteResponse.body));

  //       // Store these ids in SharedPreferences
  //       await prefs.setString('upvotedPosts', json.encode(upvotedIds));
  //       await prefs.setString('downvotedPosts', json.encode(downvotedIds));
  //     }
  //   } catch (e) {
  //     print('Error fetching or storing vote states: $e');
  //   }
  // }

  Widget _buildImageContent() {
    Widget imageContent = widget.post.imagePath != null &&
            widget.post.imagePath != ""
        ? isVideo(widget.post.imagePath!)
            ? VideoPlayerWidget(
                videoLink: widget.post.imagePath!) // Custom widget for video
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(widget.post.imagePath!, fit: BoxFit.cover),
              )
        : Image.asset('assets/apple.jpg'); // Default image if none provided

    if (widget.post.isNSFW != null && _isBlurred) {
      return ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: imageContent,
      );
    }

    return imageContent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        viewPost(widget.post.id);
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
                          const CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(
                                "https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0"),
                          ),
                          Text(
                            ' c/${widget.post.communityName}',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.post.duration != null
                                ? '• ${widget.post.duration}'
                                : '6h',
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              NSFWButton(isNSFW: widget.post.isNSFW!),
                              const SizedBox(width: 5),
                              PostCategory(category: widget.post.postCategory),
                            ]),
                            Text(
                              widget.post.title,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ])
                    ],
                  ),
                ),
                Row(
                  children: [
                    PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'save',
                          child: ListTile(
                            leading: Icon(widget.post.isSaved
                                ? Icons.bookmark
                                : Icons.bookmark_border),
                            title: Text(widget.post.isSaved
                                ? 'Unsave'
                                : 'Save'), // Dynamic text based on saved state
                          ),
                        ),
                        if (!loggedUserPost)
                          const PopupMenuItem<String>(
                            value: 'report',
                            child: ListTile(
                              leading: Icon(Icons.flag),
                              title: Text('Report'),
                            ),
                          ),
                        if (!loggedUserPost)
                          const PopupMenuItem<String>(
                            value: 'hide',
                            child: ListTile(
                              leading: Icon(Icons.visibility_off),
                              title: Text('Hide'),
                            ),
                          ),
                        loggedUserPost
                            ? const PopupMenuItem<String>(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                ),
                              )
                            : const PopupMenuItem<String>(
                                value: 'block_account',
                                child: ListTile(
                                  leading: Icon(Icons.block),
                                  title: Text('Block Account'),
                                ),
                              ),
                      ],
                      onSelected: (String value) {
                        switch (value) {
                          case 'save':
                            _toggleSave();
                            // Handle save action
                            if (widget.post.isSaved) {
                              _savePost();
                            } else {
                              _unSavePost();
                            }
                            break;
                          case 'report':
                            // Handle report action
                            _report();
                            break;
                          case 'block_account':
                            _blockAccount();
                            break;
                          case 'hide':
                            widget.onHide();
                            break;
                          case 'edit':
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditPage(widget.post.id),
                              ),
                            );
                          default:
                            break;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              widget.post.content,
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
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
                  child: _buildImageContent(),
                ),
              ),
            if (_isImagePresent())
              if (widget.post.isNSFW!)
                TextButton(
                  onPressed: _toggleBlur,
                  child: Text(_isBlurred ? 'Show' : 'Hide',
                      style: const TextStyle(fontSize: 16)),
                ),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      color: widget.post.isUpvoted
                          ? const Color.fromARGB(255, 255, 152, 0)
                          : Colors.grey,
                      onPressed: () {
                        _toggleUpvote();
                      },
                    ),
                    Text('${widget.post.upVotes}'),
                    IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        color: widget.post.isDownvoted
                            ? const Color.fromARGB(255, 156, 39, 176)
                            : Colors.grey,
                        onPressed: () {
                          _toggleDownvote();
                        }),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PostDetailsPage(
                                post: widget.post,
                                onUpvote: _toggleUpvote,
                                onDownvote: _toggleDownvote,
                                onShare: _sharePost,
                                onMakeVote: _makeVote,
                                onImageTap: () => _showImage(
                                    context, widget.post.imagePath!)),
                          ),
                        );
                      },
                    ),
                    Text('${widget.post.comments}'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
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
