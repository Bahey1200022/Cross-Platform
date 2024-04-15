import 'dart:ui';

class Post {
  final String communityName;
  final String id;
  final String? duration; // Added duration property
  int upVotes;
  final String? imagePath;
  final int? comments;
  final int shares;
  final String content;
  final String communityId;
  final String title;
  final String username;
  bool? isNSFW;
  int downVotes;
  final Image? image;
  bool isUpvoted;
  bool isDownvoted;
  bool isSaved;
  int views;
  bool? isSpoiler;
  Post(
      {required this.communityName,
      required this.id,
      this.duration, // Initialize duration
      this.upVotes = 0,
      this.isSaved = false,
      this.isUpvoted = false,
      this.isDownvoted = false,
      this.comments,
      this.shares = 0,
      this.imagePath,
      required this.content,
      required this.communityId,
      required this.title,
      this.downVotes = 0,
      this.image,
      required this.username,
      this.views = 0,
      this.isNSFW,
      this.isSpoiler});
}
