import 'dart:ui';

class Post {
  final String communityName;
  final String? duration; // Added duration property
  int upVotes;
  final String? imagePath;
  final String? comments;
  final String? shares;
  final String content;
  final String communityId;
  final String title;
  int downVotes;
  final Image? image;
  bool isUpvoted;
  bool isDownvoted;
  Post(
      {required this.communityName,
      this.duration, // Initialize duration
      this.upVotes = 0,
      this.isUpvoted = false,
      this.isDownvoted = false,
      this.comments,
      this.shares,
      this.imagePath,
      required this.content,
      required this.communityId,
      required this.title,
      this.downVotes = 0,
      this.image});
}
