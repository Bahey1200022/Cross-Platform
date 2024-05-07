// ignore_for_file: non_constant_identifier_names

import 'package:sarakel/loading_func/loadposts.dart';
import 'package:sarakel/models/comment.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/models/post.dart';

List<Post> loadposts() {
  // Existing code...

  List<Map<String, dynamic>> fetchedPosts = [
    {
      'communityId': 'community1',
      '_id': 'post1',
      'media': 'https://example.com/image1.jpg',
      'upvotes': 10,
      'downvotes': 5,
      'numberOfComments': 3,
      'nsfw': false,
      'isSpoiler': false,
      'content': 'This is the content of post 1',
      'title': 'Post 1',
      'username': 'user1',
      'numViews': 100,
    },
    {
      'communityId': 'community2',
      '_id': 'post2',
      'media': 'https://example.com/image2.jpg',
      'upvotes': 20,
      'downvotes': 2,
      'numberOfComments': 5,
      'nsfw': true,
      'isSpoiler': true,
      'content': 'This is the content of post 2',
      'title': 'Post 2',
      'username': 'user2',
      'numViews': 50,
    },
  ];

  List<Post> posts = fetchedPosts.map((p) {
    return Post(
        communityName: p['communityId'],
        id: p['_id'],
        imagePath: p['media'] != null
            ? (p['media'] is List && (p['media'] as List).isNotEmpty
                ? Uri.encodeFull(
                    extractUrl((p['media'] as List).first.toString()))
                : Uri.encodeFull(extractUrl(p['media'].toString())))
            : null,
        upVotes: p['upvotes'],
        downVotes: p['downvotes'],
        comments: p['numberOfComments'],
        shares: p['numberOfComments'] ?? 0,
        isNSFW: p['nsfw'],
        postCategory: "general",
        isSpoiler: p['isSpoiler'],
        content: p['content']?.toString() ?? "",
        communityId: p['communityId'],
        title: p['title'],
        username: p['username'],
        views: p['numViews'] ?? 0);
  }).toList();
  return posts.reversed.toList();
}

List<Community> loadcircles() {
  List<Map<String, dynamic>> Data = [
    {
      '_id': 'community1',
      'communityName': 'Community 1',
      'backgroundPicUrl': 'https://example.com/background1.jpg',
      'displayPicUrl': 'https://example.com/display1.jpg',
      'isNSFW': false,
      'type': 'public',
    },
    {
      '_id': 'community2',
      'communityName': 'Community 2',
      'backgroundPicUrl': 'https://example.com/background2.jpg',
      'displayPicUrl': 'https://example.com/display2.jpg',
      'isNSFW': true,
      'type': 'private',
    },
  ];
  List<Community> fetchedCircles = Data.map((circleData) {
    return Community(
      id: circleData['_id'],
      name: circleData['communityName'] ?? "",
      description: 'DEMO',
      backimage: circleData['backgroundPicUrl'] ??
          "https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0",
      image: circleData['displayPicUrl'] ??
          "https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0",
      is18Plus: circleData['isNSFW'],
      type: circleData['type'] ?? "public",
    );
  }).toList();
  return fetchedCircles; // Return the fetched communities list
}

List<Comment> loadcomments() {
  List<Map<String, dynamic>> data = [
    {
      '_id': 'comment1',
      'content': 'This is comment 1',
      'postID': 'post1',
      'userID': 'user1',
      'dateTime': '2022-01-01T00:00:00Z',
      'isUpvoted': false,
      'isDownvoted': false,
      'upvote': 0,
      'downVote': 0,
      'isSpoiler': false,
      'isSaved': false,
      'replyToID': '0',
    },
    {
      '_id': 'comment2',
      'content': 'This is comment 2',
      'postID': 'post1',
      'userID': 'user3',
      'dateTime': '2022-01-01T00:00:00Z',
      'isUpvoted': true,
      'isDownvoted': true,
      'upvote': 80,
      'downVote': 30,
      'isSpoiler': true,
      'isSaved': true,
      'replyToID': '1',
    },
  ];

  return data.map((json) => Comment.fromJson(json)).toList();
}
