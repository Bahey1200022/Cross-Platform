import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

///Notifications permesion
///saving device token to backend
void requestPermission() async {
  //FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  } else {}
}

void getTokens(String username, String userToken) async {
  String? token = await FirebaseMessaging.instance.getToken();
  saveToken(token!, username, userToken);
}

// Save the token to the database
// FirebaseFirestore.instance.collection('tokens').add({
//   'token': token,
//   'username': username,
// });

void saveToken(String token, String username, String usertoken) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('$BASE_URL/api/notifications/addDevice'));
  request.fields['deviceToken'] = token;

  request.headers['Authorization'] = 'Bearer $usertoken';
  var response = await request.send();
  if (response.statusCode == 200) {
  } else {}
}
