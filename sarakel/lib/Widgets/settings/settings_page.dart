import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_controller.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  final String token;
  final Settings settings;
  const SettingsPage({required this.token, required this.settings});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var swicthval1 = {};
  List swicthval = [true, true, true, true, true, true, true, true, true, true];
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
      print(swicthval1);
      print(swicthval1.length);
      print(swicthval1['showMatureContent']);
    } else {
      // Handle the error case when the API call fails
      print('Failed to fetch switch values: ${response.statusCode}');
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
      appBar: AppBar(
        title: Text(' Settings '),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Account Settings for ${jwtdecodedtoken['username']}'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('Update email address'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.lock_outlined),
            title: Text('Change password'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.public_outlined),
            title: Text('Country'),
            onTap: () {
              widget.settings.country(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Gender'),
            onTap: () {
              widget.settings.gender(context, widget.token);
            },
          ),
          ListTile(
            title: Text('Connected accounts'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: Icon(Icons.alternate_email_outlined),
            title: Text('Google'),
            trailing: widget.settings.googleConnected(widget.token)
                ? Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : null,
          ),
          ListTile(
            title: Text('Manage blocked accounts'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: Icon(Icons.block_outlined),
            title: Text('Blocked accounts'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Manage notifications'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: Icon(Icons.chat_bubble_outline),
            title: Text('Chat messages'),
            trailing: Switch(
              activeColor: Colors.blue,
              value: swicthval1['chatMessages'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  swicthval1['chatMessages'] = value;
                });
                widget.settings
                    .change("chatMessages", swicthval1['chatMessages']);
              },
            ),
            onTap: () {
              // Navigate to notifications settings page
            },
          ),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Private emails'),
            trailing: Switch(
              activeColor: Colors.blue,
              value: swicthval1['privateMessagesEmail'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  swicthval1['privateMessagesEmail'] = value;
                });
                widget.settings.change(
                    "privateMessagesEmail", swicthval1['privateMessagesEmail']);
              },
            ),
            onTap: () {
              // Navigate to notifications settings page
            },
          ),
          ListTile(
            title: Text('Manage 18+ content'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: Icon(Icons.no_adult_content_outlined),
            title: Text('Show NSFW content'),
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
            title: Text('General Preferences'),
            tileColor: Colors.grey[200], // Set tile color to light grey
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.search_outlined),
            title: Text('Show in search results'),
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
            leading: Icon(Icons.ads_click_outlined),
            title: Text('Personalize ads'),
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
            title: Text('Topics Preferences'),
            tileColor: Colors.grey[200], // Set tile color to light grey
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.date_range_outlined),
            title: Text('Dating'),
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
            leading: Icon(Icons.no_drinks_outlined),
            title: Text('Alcahol'),
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
            leading: Icon(Icons.casino_outlined),
            title: Text('Gambling'),
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
            leading: Icon(Icons.family_restroom_outlined),
            title: Text('Pregnancy and Parenting'),
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
            leading: Icon(Icons.monitor_weight_outlined),
            title: Text('Weight Loss'),
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
            title: Text('Privacy and security'),
            tileColor: Colors.grey[200], // Set tile color to light grey
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.key_outlined),
            title: Text('Privacy Policy'),
            onTap: () {
              // Navigate to privacy settings page
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Terms and conditions'),
            onTap: () {
              // Navigate to appearance settings page
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outlined),
            title: Text('Help center'),
            onTap: () {
              // Navigate to about page
            },
          ),
          ListTile(
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            textColor: Colors.red,
            title: Text('Logout'),
            onTap: () {
              widget.settings.logout(context);
            },
          ),
          ListTile(
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined),
            textColor: Colors.red,
            title: Text('Delete account'),
            onTap: () {
              widget.settings.deleteAccount(context, widget.token);
            },
          ),
        ],
      ),
    );
  }
}
