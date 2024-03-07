import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _validateEmail(String email) {
    // Regular expression for email validation
    RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    // Password validation criteria: At least 8 characters
    return password.length >= 8;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/welcome');
        return false;
      },
      child: Scaffold(
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
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                'Log in',
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
                SizedBox(height: 70.0),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome to Sarakel',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
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
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () async {
                          // Navigator.pushNamed(context, '/username');
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          String type = 'User';
                          if (_validateEmail(email) &&
                              _validatePassword(password)) {
                            // Both email and password are valid, proceed
                            var data = {
                              "email": email,
                              "password": password,
                              "type": type
                            };
                            print(data);
                            var url =
                                Uri.parse('http://192.168.1.22:3000/data');

                            try {
                              var response = await http.post(
                                url,
                                body: json.encode(data),
                                headers: {'Content-Type': 'application/json'},
                              );
                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                Navigator.pushNamed(context, '/username');

                                ////////////////
                              } else {
                                print('\x1B[33mThis is yellow text\x1B[0m');
                                print(response.statusCode);
                              }
                            } catch (e) {
                              // Handle network errors
                              print('Error: $e');
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'Invalid email or password. Password should be more than 8 characters'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
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
      ),
    );
  }
}
