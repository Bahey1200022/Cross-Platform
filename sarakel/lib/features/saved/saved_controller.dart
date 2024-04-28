import 'package:sarakel/loadposts.dart';
import 'package:sarakel/models/post.dart';

/// fetching saved posts list
class SavedController {
  Future<List<Post>> fetchSavedPosts() async {
    return fetchPosts('api/subreddit/getBest');
  }
}
