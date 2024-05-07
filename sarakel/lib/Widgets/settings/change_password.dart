import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/settings/change_Pass.dart';
import 'package:sarakel/Widgets/settings/passwords_functions.dart';
import 'package:sarakel/Widgets/settings/settings_controller.dart';
import 'package:sarakel/Widgets/settings/settings_page.dart';

class ChangePasswordPage extends StatefulWidget {
  final String token;
  final Settings settings;
  bool isSignedInGoogle = false;
  ChangePasswordPage(
      {super.key,
      required this.token,
      required this.settings,
      required this.isSignedInGoogle});
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final myOldPassword = TextEditingController();
  final myNewPassword = TextEditingController();
  final myConfirmPassword = TextEditingController();
  String token = '';
  bool showOldPasword = false;
  bool showNewPassword = false;
  bool showConfirmedPassword = false;
  bool isLoggedThroughGoogle = false;

  @override
  void initState() {
    super.initState();
    token = widget.token;
    isLoggedThroughGoogle = widget.isSignedInGoogle;
  }

  // Future<void> getToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = this.token;
  // setState(() {
  //   this.token = token!;
  //   print(token);
  // });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Visibility(
                    visible: !isLoggedThroughGoogle,
                    child: TextField(
                      controller: myOldPassword,
                      decoration: InputDecoration(
                        hintText: 'Old Password',
                        suffixIcon: IconButton(
                            icon: Icon(showOldPasword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                showOldPasword = !showOldPasword;
                              });
                            }),
                      ),
                      obscureText: showOldPasword,
                    )),
                TextField(
                  controller: myNewPassword,
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    suffixIcon: IconButton(
                        icon: Icon(showNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            showNewPassword = !showNewPassword;
                          });
                        }),
                  ),
                  obscureText: showNewPassword,
                ),
                TextField(
                  controller: myConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Confirm New Password',
                    suffixIcon: IconButton(
                        icon: Icon(showConfirmedPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            showConfirmedPassword = !showConfirmedPassword;
                          });
                        }),
                  ),
                  obscureText: showConfirmedPassword,
                ),
                ElevatedButton(
                    onPressed: () {
                      bool isvalid = isNewPasswordValid(
                          myNewPassword.text, myConfirmPassword.text);
                      print(isvalid);
                      if (isvalid) {
                        // if (isOldPasswordValid(
                        //     myOldPassword.text, 'dataBasePassword')) {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => SettingsPage(
                        //           token: token,
                        //           settings: Settings(token: token)),
                        //     ),
                        //   );
                        // } else {
                        //   showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         title: const Text('Invalid old Password'),
                        //         content: const Text(
                        //             'please check your old password and try again.'),
                        //         actions: <Widget>[
                        //           TextButton(
                        //             onPressed: () {
                        //               Navigator.of(context).pop();
                        //             },
                        //             child: const Text('OK'),
                        //           ),
                        //         ],
                        //       );
                        //     },
                        //   );
                        // }
                        changePassword(context, myNewPassword.text, token,
                            myOldPassword.text);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Invalid Password'),
                              content: const Text(
                                  'Password must be at least 8 characters long and match the confirmation password.'),
                              actions: <Widget>[
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
                      ;

                      print(myOldPassword.text);
                      print(myNewPassword.text);
                      print(myConfirmPassword.text);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 153, 0)),
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
