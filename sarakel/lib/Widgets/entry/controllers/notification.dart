import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

///Notifications permesion
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
    print('User granted permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

void getTokens(String username) async {
  String? token = await FirebaseMessaging.instance.getToken();
  print('Token: $token');
  saveToken(token!, username);
}

void saveToken(String token, String username) async {
  // Save the token to the database
  // FirebaseFirestore.instance.collection('tokens').add({
  //   'token': token,
  //   'username': username,
  // });
}
