import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/entry/controllers/google.dart';
import 'package:sarakel/Widgets/entry/controllers/user_entry_controller.dart';

bool _validateEmail(String email) {
  // Regular expression for email validation
  RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email) || email.isNotEmpty;
}

bool _validatePassword(String password) {
  // Password validation criteria: At least 8 characters
  return password.length >= 3;
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPassword = false; // Track password visibility
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pushNamed(context, '/welcome');
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: const Text(
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
              const SizedBox(height: 50.0),
              const Text(
                'Log in',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/google_logo.png', height: 24.0),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () async {
                        // Handle continue with googgle
                        await GoogleService().signInWithGoogle(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 244, 236, 236),
                        ),
                      ),
                      child: const Text(
                        'Continue with google',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                        cursorColor: Colors.black, //Hafez
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.black), //Hafez
                          labelText: 'Email or username',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      // ...
                      child: TextFormField(
                        cursorColor: Colors.black, //Hafez
                        controller: _passwordController,
                        obscureText:
                            !showPassword, // Hide password if showPassword is false
                        decoration: InputDecoration(
                          labelStyle:
                              const TextStyle(color: Colors.black), //Hafez
                          labelText: 'Password',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16.0),
                          suffixIcon: IconButton(
                            icon: Icon(showPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                showPassword =
                                    !showPassword; // Toggle password visibility
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password
                          Navigator.pushNamed(context,
                              '/forgotpassword'); // Handle forgot password
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        UserController oldUserController = UserController(
                            emailScreen: 'emailScreen',
                            passwordScreen: 'passwordScreen');

                        if (_validateEmail(email) &&
                            _validatePassword(password)) {
                          if (await oldUserController.loginUser(
                              context, email, password)) {
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text(
                                      'Incorrect username,email or password'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }

                        ///all if
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.orange,
                        ),
                      ),
                      child: const Text(
                        'Continue',
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
