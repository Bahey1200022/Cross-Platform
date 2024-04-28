import 'package:sarakel/loadposts.dart';
import 'package:sarakel/models/post.dart';

Future<List<Post>> loadRecentHistory() async {
  return fetchPosts('api/subreddit/getBest');
}
