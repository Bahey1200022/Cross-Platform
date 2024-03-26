import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //title: Text('Sarakel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo_2d.png', height: 150.0),
            Text(
              'Welcome to Sarakel!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      'Continue with email',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 244, 236, 236),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/google_logo.png', height: 24.0),
                  SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      // Handle continue with Google
                    },
                    child: Text(
                      'Continue with Google',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 244, 236, 236),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/facebook_logo.png', height: 24.0),
                  SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      // Handle continue with Facebook
                    },
                    child: Text(
                      'Continue with Facebook',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 244, 236, 236),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 160.0),
            Text('Already in Sarakel ?'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
