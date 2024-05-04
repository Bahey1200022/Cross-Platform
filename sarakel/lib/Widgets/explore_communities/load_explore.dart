import 'package:sarakel/loading_func/loadcommunities.dart';
import 'package:sarakel/models/community.dart';
import 'package:shared_preferences/shared_preferences.dart';

///load communities that user has not joined
Future<List<Community>> explore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString('username');
  return loadCommunities('/api/user/$username/communitiesNotJoined');
}
