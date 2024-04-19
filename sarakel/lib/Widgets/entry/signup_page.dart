import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/entry/controllers/user_entry_controller.dart';
import 'username_page.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pushNamed(context, '/welcome');
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
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
                const SizedBox(height: 70.0),
                const Text.rich(
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
                              labelText: 'Email',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.0),
                              labelStyle: TextStyle(color: Colors.black) //Hafez
                              ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          cursorColor: Colors.black, //Hafez
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.0),
                              labelStyle: TextStyle(color: Colors.black) //Hafez
                              ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () async {
                          // Navigator.pushNamed(context, '/username');
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          if (_validateEmail(email) &&
                              _validatePassword(password)) {
                            // Both email and password are valid, proceed
                            UserController userController = UserController(
                                emailScreen: email, passwordScreen: password);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UsernamePage(
                                  userController: userController,
                                ),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text(
                                      'Invalid email or password. Password should be more than 8 characters'),
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
      ),
    );
  }
}
