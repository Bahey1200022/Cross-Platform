import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/entry/controllers/user_entry_controller.dart';

class UsernamePage extends StatefulWidget {
  final UserController userController;
  const UsernamePage({super.key, required this.userController});

  @override
  _UsernamePageState createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  TextEditingController usernameController = TextEditingController();
  String _errorText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
                'Create your username',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Most Sarakelers use an anonymous username.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'You won\'t be able to change it later.',
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
                        cursorColor: Colors.black, //Hafez,
                        controller: usernameController,
                        onChanged: (value) async {
                          value = value.trim();
                          String formattedUsername = value;
                          bool usernameExists = await widget.userController
                              .usernameExists(formattedUsername);

                          setState(() {
                            if (usernameExists) {
                              _errorText =
                                  'user with the name "$value" already exists. Please choose a different name.';
                            } else if (value.isEmpty || value.length < 3) {
                              _errorText = 'please enter a valid username';
                            } else {
                              _errorText = '"$value" available';
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.black), //Hafez
                          labelText: 'Username',
                          prefixText: 'u/',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                    // if (_errorText
                    //     .isNotEmpty) // Only show error message if there's an error
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        _errorText,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        String username = usernameController.text.trim();
                        String formattedUsername = username;
                        if (await widget.userController
                            .usernameExists(formattedUsername)) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Username already taken'),
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
                        } else {
                          widget.userController.usernameScreen =
                              formattedUsername;
                          widget.userController.passToServer(context);
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
    );
  }
}
