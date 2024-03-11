import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<bool> usernameExists(String username) async {
  final response = await http.get(Uri.parse('http://localhost:3000/users'));

  if (response.statusCode == 200) {
    // Decode the response body from JSON
    final dynamic users = json.decode(response.body);
    print(users);
    // Iterate through the list of users
    for (var user in users) {
      // Check if the provided username matches any existing username
      if (user['username'] == username) {
        return true; // Username exists
      }
    }
    return false; // Username doesn't exist
  } else {
    throw Exception('Failed to load user data');
  }
}

class UsernamePage extends StatelessWidget {
  String email;
  String password;
  TextEditingController usernameController = TextEditingController();
  UsernamePage({required this.email, required this.password});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('Create Username'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
              SizedBox(height: 50.0),
              Text(
                'Create your username',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                'Most Sarakelers use an anonymous username.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'You won\'t be able to change it later.',
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
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        String username = usernameController.text.trim();
                        print(username);
                        String formattedUsername = "u/$username";
                        print(username);
                        if (await usernameExists(formattedUsername)) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text('Username already taken'),
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
                        } else {
                          var data = {
                            "email": email,
                            "password": password,
                            "token": "true",
                            "username": formattedUsername
                          };
                          var url = Uri.parse('http://localhost:3000/users');

                          try {
                            var response = await http.post(
                              url,
                              body: json.encode(data),
                              headers: {'Content-Type': 'application/json'},
                            );
                            if (response.statusCode == 200 ||
                                response.statusCode == 201) {
                              Navigator.pushNamed(context, '/login');

                              //     ////////////////
                            } else {
                              print(response.statusCode);
                            }
                          } catch (e) {
                            // Handle network errors
                            print('Error: $e');
                          }
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
    );
  }
}
