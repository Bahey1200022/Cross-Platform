import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void disableNotification(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Disable Notifications'),
        content: const Text('Are you sure you want to disable notifications?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Disable'),
            onPressed: () {
              // Perform the disable notification logic here
              initializeFirebaseMessaging();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void initializeFirebaseMessaging() {
  // Initialize Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Configure Firebase Messaging to handle notifications silently
  messaging.setForegroundNotificationPresentationOptions(
    alert: false,
    badge: false,
    sound: false,
  );
}

void enableNotification(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enable Notifications'),
        content: const Text('Are you sure you want to enable notifications?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Enable'),
            onPressed: () {
              // Perform the enable notification logic here
              FirebaseMessaging messaging = FirebaseMessaging.instance;

              // Configure Firebase Messaging to handle notifications silently
              messaging.setForegroundNotificationPresentationOptions(
                alert: true,
                badge: true,
                sound: true,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
