import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:sarakel/providers/user_communities.dart';
import 'package:sarakel/providers/user_provider.dart';
import 'package:sarakel/screens/feed/chat_page.dart';
import 'package:sarakel/screens/feed/inbox_page.dart';
import './screens/entry/login_page.dart';
import './screens/entry/signup_page.dart';
import './screens/entry/username_page.dart';
import './screens/entry/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/feed/homescreen.dart';
import './screens/feed/create_post.dart';
import './screens/feed/explore_communities.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      /////keeping user logged in
      future: _getHomescreenFromCache(), // Check homescreen value from cache
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Display loading indicator while fetching data
        } else {
          bool homescreen = snapshot.data ??
              false; // Get homescreen value from snapshot, default to false
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<UserProvider>(
                  create: (_) => UserProvider()),
              ChangeNotifierProvider<UserCommunitiesProvider>(
                  create: (_) => UserCommunitiesProvider())
            ],
            child: MaterialApp(
              title: 'Sarakel',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: homescreen ? SarakelHomeScreen() : WelcomePage(),
              routes: {
                '/welcome': (context) => WelcomePage(),
                '/login': (context) => LoginPage(),
                '/signup': (context) => SignupPage(),
                '/home': (context) => SarakelHomeScreen(),
                '/create_post': (context) => CreatePost(),
                '/communities': (context) => ExploreCommunities(),
                '/chat': (context) => ChatSection(),
                '/inbox': (context) => InboxSection(),
              },
              debugShowCheckedModeBanner:
                  false, // Set debugShowCheckedModeBanner to false
            ),
          );
        }
      },
    );
  }
}

Future<bool> _getHomescreenFromCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? homescreen = prefs.getBool('homescreen');
  if (homescreen == null) {
    // Perform one-time initialization if homescreen value is not stored
    await prefs.setBool('homescreen', false); // Initialize homescreen as false
    return false; // Return false as initial value
  }
  return true; // Return stored homescreen value
}