class Comment {
  final String id;
  final String postID; // You may want to add postId to the comment model
  final String content;
  final String userID;
  final String duration;
  String?
      replyToID; // You may want to handle duration dynamically based on the creation date
  int upvote;
  int downVote;
  bool isSaved;
  bool? isSpoiler; // For handling save functionality

  Comment({
    required this.id,
    required this.content,
    required this.postID,
    required this.userID,
    required this.duration,
    this.upvote = 0,
    this.downVote = 0,
    this.isSaved = false,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      content: json['content'],
      userID: json['username'],
      postID: json['PostId'],
      duration: json['duration'],
      upvote: json['upvotes'],
      downVote: json['downvotes'],
      isSaved: json['isSaved'],
    );
  }
}
