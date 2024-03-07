import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import './screens/login_page.dart';
import './screens/signup_page.dart';
import './screens/username_page.dart';
import './screens/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './screens/homescreen.dart';
import './screens/create_post.dart';
import './screens/explore_communities.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sarakel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/username': (context) => UsernamePage(),
        '/home': (context) => SarakelHomeScreen(),
        '/create_post': (context) => CreatePost(),
        '/communities': (context) => ExploreCommunities(),
      },
      debugShowCheckedModeBanner:
          false, // Set debugShowCheckedModeBanner to false
    );
  }
}
