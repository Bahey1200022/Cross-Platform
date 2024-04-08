import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sarakel/Widgets/home/controllers/home_screen_controller.dart';
import 'package:sarakel/Widgets/home/homescreen.dart';
import 'package:sarakel/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GoogleService {
  SharedPreferences? prefs;

  signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      print('hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
      print(credential.accessToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      final accessToken = credential.accessToken;
      var data = {'token': accessToken};
      const url = '$BASE_URL/verifyToken';
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Request successful
        prefs = await SharedPreferences.getInstance();
        var jsonData = json.decode(response.body);

        var token = jsonData['token'];

        prefs!.setString('token', token);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SarakelHomeScreen(
                    homescreenController: HomescreenController(token: token))));
      } else {
        // Request failed
        print('Post request failed with status code: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      print('Error signing in with Google: $error');
      print('Stack trace: $stackTrace');
    }
  }
}
