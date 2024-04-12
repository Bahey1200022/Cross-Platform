import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'settings_controller.dart';

class SettingsPage extends StatefulWidget {
  final String token;
  final Settings settings;
  const SettingsPage({required this.token, required this.settings});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List swicthval = [
    false,
    true,
    true,
    false,
    true,
    true,
    false,
    true,
    true,
    false
  ];

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
            title: Text('Update email Address'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Change password'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Country'),
            onTap: () {
              widget.settings.country(context);
            },
          ),
          ListTile(
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
            title: Text('Blocked accounts'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Manage notifications'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            title: Text('Chat messages'),
            trailing: Switch(
              value: swicthval[0],
              onChanged: (bool value) {
                setState(() {
                  swicthval[0] = value;
                });
                widget.settings.change("chatMessages", swicthval[0]);
              },
            ),
            onTap: () {
              // Navigate to notifications settings page
            },
          ),
          ListTile(
            title: Text('Private emails'),
            trailing: Switch(
              value: swicthval[1],
              onChanged: (bool value) {
                setState(() {
                  swicthval[1] = value;
                });
                widget.settings.change("privateMessagesEmail", swicthval[1]);
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
            title: Text('Show NSFW content'),
            trailing: Switch(
              value: swicthval[2],
              onChanged: (bool value) {
                setState(() {
                  swicthval[2] = value;
                });
                widget.settings.change("showMatureContent", swicthval[2]);
              },
            ),
          ),
          ListTile(
            title: Text('General Preferences'),
            tileColor: Colors.grey[200], // Set tile color to light grey
            onTap: () {},
          ),
          ListTile(
            title: Text('Show in search results'),
            trailing: Switch(
              value: swicthval[3],
              onChanged: (bool value) {
                setState(() {
                  swicthval[3] = value;
                });
                widget.settings.change("showInSearch", swicthval[3]);
              },
            ),
          ),
          ListTile(
            title: Text('Personalize ads'),
            trailing: Switch(
              value: swicthval[4],
              onChanged: (bool value) {
                setState(() {
                  swicthval[4] = value;
                });
                widget.settings.change("personalizeAds", swicthval[4]);
              },
            ),
          ),
          ListTile(
            title: Text('Topics Preferences'),
            tileColor: Colors.grey[200], // Set tile color to light grey
            onTap: () {},
          ),
          ListTile(
            title: Text('Dating'),
            trailing: Switch(
              value: swicthval[5],
              onChanged: (bool value) {
                setState(() {
                  swicthval[5] = value;
                });
                widget.settings.change("dating", swicthval[5]);
              },
            ),
          ),
          ListTile(
            title: Text('Alcahol'),
            trailing: Switch(
              value: swicthval[6],
              onChanged: (bool value) {
                setState(() {
                  swicthval[6] = value;
                });
                widget.settings.change("alcohol", swicthval[6]);
              },
            ),
          ),
          ListTile(
            title: Text('Gambling'),
            trailing: Switch(
              value: swicthval[7],
              onChanged: (bool value) {
                setState(() {
                  swicthval[7] = value;
                });
                widget.settings.change("gambling", swicthval[7]);
              },
            ),
          ),
          ListTile(
            title: Text('Pregnancy and Parenting'),
            trailing: Switch(
              value: swicthval[8],
              onChanged: (bool value) {
                setState(() {
                  swicthval[8] = value;
                });
                widget.settings.change("pregnancyAndParenting", swicthval[8]);
              },
            ),
          ),
          ListTile(
            title: Text('Weight Loss'),
            trailing: Switch(
              value: swicthval[9],
              onChanged: (bool value) {
                setState(() {
                  swicthval[9] = value;
                });
                widget.settings.change("weightLoss", swicthval[9]);
              },
            ),
          ),
          ListTile(
            title: Text('Privacy and security'),
            tileColor: Colors.grey[200], // Set tile color to light grey
            onTap: () {},
          ),
          ListTile(
            title: Text('Privacy Policy'),
            onTap: () {
              // Navigate to privacy settings page
            },
          ),
          ListTile(
            title: Text('Terms and conditions'),
            onTap: () {
              // Navigate to appearance settings page
            },
          ),
          ListTile(
            title: Text('Help center'),
            onTap: () {
              // Navigate to about page
            },
          ),
          ListTile(
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              widget.settings.logout(context);
            },
          ),
          ListTile(
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
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
