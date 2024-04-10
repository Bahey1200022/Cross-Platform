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
  var swicthval = true;

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
            title: Text('Notifications'),
            onTap: () {
              // Navigate to notifications settings page
            },
          ),
          ListTile(
            title: Text('Manage 18+ content'),
            tileColor: Colors.grey[200], // Set tile color to light grey
            trailing: Switch(
              value: swicthval,
              onChanged: (bool value) {
                setState(() {
                  swicthval = value;
                });
                print(swicthval);
              },
            ),
          ),
          ListTile(
            title: Text('Show NSFW content'),
            trailing: Switch(
              value: widget.settings.prefs?.showNSFW ?? false,
              onChanged: (bool value) {
                setState(() {
                  widget.settings.NSFW();
                  swicthval = value;
                });
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
