import 'package:shared_preferences/shared_preferences.dart';

///checking if the user has the token and already logged to direct him to either tghe home screen or the welcome screen
Future<bool> isLoggedInUser(String userName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loggedInUsername = prefs.getString('username');
  if (loggedInUsername == userName) {
    return true;
  } else {
    return false;
  }
}
