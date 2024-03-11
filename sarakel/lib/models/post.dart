class Post {
  final String communityName;
  final String? duration; // Added duration property
  final int upVotes;
  final int comments;
  final int shares;
  final String content;
  final String communityId;

  Post({
    required this.communityName,
    this.duration, // Initialize duration
    required this.upVotes,
    required this.comments,
    required this.shares,
    required this.content,
    required this.communityId,
  });
}
