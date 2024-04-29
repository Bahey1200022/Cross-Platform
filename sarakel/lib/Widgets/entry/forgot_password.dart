// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailOrUsernameController =
      TextEditingController();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
              const SizedBox(height: 50.0),
              const Text(
                'Forgot Password?',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Enter your email address or username and',
                style: TextStyle(fontSize: 16.0),
              ),
              const Text(
                "we'll send you a link to reset your password",
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
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
                        decoration: const InputDecoration(
                          labelText: 'Email or Username',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        String emailOrUsername =
                            emailOrUsernameController.text.trim();
                        var data = {'emailOrUsername': emailOrUsername};
                        var url =
                            Uri.parse('$BASE_URL/api/login/forget_password');
                        try {
                          var response = await http.post(
                            url,
                            body: json.encode(data),
                            headers: {'Content-Type': 'application/json'},
                          );
                          if (response.statusCode == 200) {
                            // Password reset email sent successfully
                            // Optionally, show a success message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Password reset email sent successfully'),
                              ),
                            );
                          } else {
                            // Failed to send password reset email, handle the error
                            print(
                                'Failed to send password reset email: ${response.statusCode}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Failed to send password reset email'),
                              ),
                            );
                          }
                        } catch (e) {
                          // Handle network errors
                          print('Error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Network error occurred'),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.orange,
                        ),
                      ),
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(color: Colors.white),
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
