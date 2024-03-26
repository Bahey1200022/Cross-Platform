import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailOrUsernameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo_2d.png', height: 100.0),
              SizedBox(height: 50.0),
              Text(
                'Forgot Password?',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                'Enter your email address or username and',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                "we'll send you a link to reset your password",
                style: TextStyle(fontSize: 16.0),
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
                        controller: emailOrUsernameController,
                        decoration: InputDecoration(
                          labelText: 'Email or Username',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Reset Password button press
                      },
                      child: Text(
                        'Reset Password',
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
