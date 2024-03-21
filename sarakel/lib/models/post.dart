import 'dart:ui';

class Post {
  final String communityName;
  final String? duration; // Added duration property
  final String? upVotes;
  final String? comments;
  final String? shares;
  final String content;
  final String communityId;
  final String title;
  final String? downVotes;
  final Image? image;
  Post(
      {required this.communityName,
      this.duration, // Initialize duration
      this.upVotes,
      this.comments,
      this.shares,
      required this.content,
      required this.communityId,
      required this.title,
      this.downVotes,
      this.image});
}
