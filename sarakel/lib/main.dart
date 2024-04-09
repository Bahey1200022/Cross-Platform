import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/controllers/home_screen_controller.dart';
import 'package:sarakel/Widgets/home/homescreen.dart';
import 'package:sarakel/providers/user_communities.dart';
import 'package:sarakel/providers/user_provider.dart';
import 'Widgets/entry/login_page.dart';
import 'Widgets/entry/signup_page.dart';
import 'Widgets/entry/welcome_page.dart';
import 'package:provider/provider.dart';
import 'Widgets/entry/forgot_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  runApp(MyApp(
    startWithToken: token != null,
    token: token,
  ));

  ///to see wether the user is logged in or not
}

class MyApp extends StatelessWidget {
  final bool startWithToken;

  /// Represents a token that can be nullable.
  final String? token;

  const MyApp({Key? key, required this.startWithToken, this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider()), //for mock api
        ChangeNotifierProvider<UserCommunitiesProvider>(
            create: (_) =>
                UserCommunitiesProvider()) // Add UserCommunitiesProvider
      ],
      child: MaterialApp(
        title: 'Sarakel',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: startWithToken
            ? SarakelHomeScreen(
                homescreenController: HomescreenController(token: token!),
              )
            : WelcomePage(),
        routes: {
          '/welcome': (context) => WelcomePage(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/forgotpassword': (context) => ForgotPasswordPage(),
        },
        debugShowCheckedModeBanner:
            false, // Set debugShowCheckedModeBanner to false
      ),
    );
  }
}
