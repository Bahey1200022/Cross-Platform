import 'package:flutter/material.dart';
import '../widgets/google_signin.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pushNamed(context, '/welcome');
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: Text(
              'Sign Up',
              style: TextStyle(color: Color.fromARGB(255, 58, 56, 56)),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo_2d.png', height: 100.0),
              SizedBox(height: 50.0),
              Text(
                'Log in',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/google_logo.png', height: 24.0),
                    SizedBox(width: 8.0),
                    GoogleSignInButton(),
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
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'OR',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email or Username',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Handle continue
                        Navigator.pushNamed(context, '/home');
                      },
                      child: Text(
                        'Continue',
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
            ],
          ),
        ),
      ),
    );
  }
}
