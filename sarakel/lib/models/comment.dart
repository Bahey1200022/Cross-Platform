import 'package:sarakel/loading_func/loadposts.dart';

class Comment {
  final String id;
  final String postID;
  final String content;
  final String userID;
  final String dateTime;
  bool isUpvoted;
  bool isDownvoted;
  int upvote;
  int downVote;
  final bool isSpoiler;
  bool isSaved;
  final String? replyToID; // Assuming this can be null

  Comment({
    required this.id,
    required this.postID,
    required this.content,
    required this.userID,
    required this.dateTime,
    this.isUpvoted = false,
    this.isDownvoted = false,
    this.upvote = 0,
    this.downVote = 0,
    this.isSpoiler = false,
    this.isSaved = false,
    this.replyToID,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      postID: json['postID'],
      content: json['content'],
      userID: json['userID'],
      dateTime: formatDateTime(json['dateTime']),
      upvote: json['upvote'] ?? 0,
      downVote: json['downVote'] ?? 0,
      isSpoiler: json['isSpoiler'] ?? false,
      replyToID: json['replyToID'],
    );
  }
}
