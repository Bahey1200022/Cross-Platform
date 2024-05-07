import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/Widgets/settings/change_email.dart';
import 'package:sarakel/Widgets/settings/change_password.dart';
import 'package:sarakel/constants.dart';
import 'package:sarakel/features/mode_tools/general/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_controller.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/Widgets/settings/muted_comunities.dart';
import 'package:sarakel/Widgets/settings/chat_permissions.dart';

class SettingsPage extends StatefulWidget {
  final String token;
  final Settings settings;
  const SettingsPage({super.key, required this.token, required this.settings});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final myController = TextEditingController();

  var swicthval1 = {};
  List swicthval = [true, true, true, true, true, true, true, true, true, true];
  bool isHavingEmailAdress = true;
  Future<void> fetchSwitchValues() async {
    // Make an API call to fetch the switch values from the backend
    // Replace 'apiEndpoint' with the actual endpoint URL
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await http.get(
      Uri.parse('$BASE_URL/api/v1/me/prefs'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      // Parse the response body and assign the switch values to the 'swicthval' list
      final data = jsonDecode(response.body);
      setState(() {
        swicthval1 = data['settings'];
      });
    } else {
      // Handle the error case when the API call fails
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSwitchValues();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(widget.token);

    return Scaffold(
      // appBar: AppBar(
      //     // title: const Text(' Settings '),
      //     ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Account settings for ${jwtdecodedtoken['username']}'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Update email address'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  String newEmail = myController.text.trim();
                                  if (validateEmail(newEmail) == false) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please enter a valid email address')));
                                  } else {
                                    // Add your logic for the continue button here
                                    changeEmail(
                                        newEmail, widget.token, context);
                                  }
                                },
                                child: const Text('Continue'),
                              ),
                            ],
                          ),
                        ],
                        title: const Text('Update email address'),
                        contentPadding: const EdgeInsets.all(20.0),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: myController,
                              decoration: const InputDecoration(
                                hintText: 'Enter your new email address',
                              ),
                            ),
                          ],
                        ),
                      ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outlined),
            title: const Text('Change password'),
            onTap: () {
              if (isHavingEmailAdress) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordPage(
                        token: widget.token,
                        isSignedInGoogle: swicthval1['signedInWithGoogle'],
                        settings: Settings(token: widget.token),
                      ),
                    ));
              }
            },
          ),
          ListTile(
              leading: const Icon(Icons.public_outlined),
              title: const Text('Country'),
              onTap: () {
                widget.settings.country(context);
              }),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Gender'),
            onTap: () {
              widget.settings.gender(context, widget.token);
            },
          ),
          ListTile(
            title: const Text('Connected accounts'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email_outlined),
            title: const Text('Google'),
            trailing: swicthval1['signedInWithGoogle'] != null
                ? swicthval1['signedInWithGoogle']
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : null
                : null,
          ),
          ListTile(
            title: const Text('Safety'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: const Icon(Icons.block_outlined),
            title: const Text('Manage blocked accounts'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.volume_off_outlined),
            title: const Text('Manage muted comuninties'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MutedCommunities(
                    token: widget.token,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat_outlined),
            title: const Text('Chat and messaging permisions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPermissions(
                    token: widget.token,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Manage notifications'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: const Text('Chat messages'),
            trailing: Switch(
              activeColor: Colors.blue,
              value: swicthval1['chatMessages'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  swicthval1['chatMessages'] = value;
                });
                widget.settings
                    .change("chatMessages", swicthval1['chatMessages']);
                if (swicthval1['chatMessages']) {
                  enableNotification(context);
                } else {
                  disableNotification(context);
                }
              },
            ),
            onTap: () {
              // Navigate to notifications settings page
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Private emails'),
            trailing: Switch(
              activeColor: Colors.blue,
              value: swicthval1['privateMessagesEmail'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  swicthval1['privateMessagesEmail'] = value;
                });
                widget.settings.change(
                    "privateMessagesEmail", swicthval1['privateMessagesEmail']);
                if (swicthval1['privateMessagesEmail']) {
                  enableNotification(context);
                } else {
                  disableNotification(context);
                }
              },
            ),
            onTap: () {
              // Navigate to notifications settings page
            },
          ),
          ListTile(
            title: const Text('Manage 18+ content'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: const Icon(Icons.no_adult_content_outlined),
            title: const Text('Show NSFW content'),
            trailing: Switch(
              activeColor: Colors.blue,
              value: swicthval1['showMatureContent'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  swicthval1['showMatureContent'] = value;
                });
                widget.settings.change(
                    "showMatureContent", swicthval1['showMatureContent']);
              },
            ),
          ),
          ListTile(
            title: const Text('General Preferences'),
            tileColor: Colors.grey[200], // Set tile color to light grey
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.search_outlined),
            title: const Text('Show in search results'),
            trailing: Switch(
              activeColor: Colors.blue,
              value: swicthval1['showInSearch'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  swicthval1['showInSearch'] = value;
                });
                widget.settings
                    .change("showInSearch", swicthval1['showInSearch']);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.ads_click_outlined),
            title: const Text('Personalize ads'),
            trailing: Switch(
              activeColor: Colors.blue,
              value: swicthval1['personalizeAds'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  swicthval1['personalizeAds'] = value;
                });
                widget.settings
                    .change("personalizeAds", swicthval1['personalizeAds']);
              },
            ),
          ),
          ListTile(
            title: const Text('Topics Preferences'),
            tileColor: Colors.grey[200], // Set tile color to light grey
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.date_range_outlined),
            title: const Text('Dating'),
            trailing: Switch(
              activeColor: Colors.blue,
              value: swicthval1['dating'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  swicthval1['dating'] = value;
                });
                widget.settings.change("dating", swicthval1['dating']);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.no_drinks_outlined),
            title: const Text('Alcahol'),
            trailing: Switch(
              activeColor: Colors.blue,
              value: swicthval1['alcohol'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  swicthval1['alcohol'] = value;
                });
                widget.settings.change("alcohol", swicthval1['alcohol']);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.casino_outlined),
            title: const Text('Gambling'),
            trailing: Switch(
              activeColor: Colors.blue,
              value: swicthval1['gambling'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  swicthval1['gambling'] = value;
                });
                widget.settings.change("gambling", swicthval1['gambling']);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.family_restroom_outlined),
            title: const Text('Pregnancy and Parenting'),
            trailing: Switch(
              activeColor: Colors.blue,
              value: swicthval1['pregnancyAndParenting'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  swicthval1['pregnancyAndParenting'] = value;
                });
                widget.settings.change("pregnancyAndParenting",
                    swicthval1['pregnancyAndParenting']);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.monitor_weight_outlined),
            title: const Text('Weight Loss'),
            trailing: Switch(
              activeColor: Colors.blue,
              value: swicthval1['weightLoss'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  swicthval1['weightLoss'] = value;
                });
                widget.settings.change("weightLoss", swicthval1['weightLoss']);
              },
            ),
          ),
          ListTile(
            title: const Text('Privacy and security'),
            tileColor: Colors.grey[200], // Set tile color to light grey
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.key_outlined),
            title: const Text('Privacy policy'),
            onTap: () {
              // Navigate to privacy settings page
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Terms and conditions'),
            onTap: () {
              // Navigate to appearance settings page
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outlined),
            title: const Text('Help center'),
            onTap: () {
              // Navigate to about page
            },
          ),
          ListTile(
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            textColor: Colors.red,
            title: const Text('Logout'),
            onTap: () {
              widget.settings.logout(context);
            },
          ),
          ListTile(
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined),
            textColor: Colors.red,
            title: const Text('Delete account'),
            onTap: () {
              widget.settings.deleteAccount(context, widget.token);
            },
          ),
        ],
      ),
    );
  }
}
