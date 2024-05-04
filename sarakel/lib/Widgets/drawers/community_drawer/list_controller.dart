import 'package:sarakel/loading_func/loadcommunities.dart';
import 'package:sarakel/models/community.dart';

///loading communities joined by user
Future<List<Community>> loadCircles() async {
  return loadCommunities('/api/user/:username/communitiesJoined');
}
