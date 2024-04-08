import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/entry/controllers/google.dart';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextButton(
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
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/google_logo.png', height: 24.0),
                  SizedBox(width: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextButton(
<<<<<<< HEAD
                      onPressed: () {
                        // Handle continue with Google
=======
                      onPressed: () async {
                        // Handle continue with Google
                        await GoogleService().signInWithGoogle();
>>>>>>> d9dbe1d13d0b59d67d7a8717c229929dc61b551f
                      },
                      child: Text(
                        'Continue with Google',
                        style: TextStyle(color: Colors.black),
<<<<<<< HEAD
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 244, 236, 236),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.facebook,color: Colors.blue,),
                  SizedBox(width: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextButton(
                      onPressed: () {
                        // Handle continue with Facebook
                      },
                      child: Text(
                        'Continue with Facebook',
                        style: TextStyle(color: Colors.black),
                      ),
=======
                      ),
>>>>>>> d9dbe1d13d0b59d67d7a8717c229929dc61b551f
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 244, 236, 236),
                        ),
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
