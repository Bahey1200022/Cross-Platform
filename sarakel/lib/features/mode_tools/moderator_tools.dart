import 'package:flutter/material.dart';

class ModeratorTools extends StatefulWidget {
  final String token;
  ModeratorTools({required this.token});
  @override
  _ModeratorToolsState createState() => _ModeratorToolsState();
}

class _ModeratorToolsState extends State<ModeratorTools> {
  bool anyOneOnSarakel = true;
  bool acountOlderThan30Days = true;
  bool Nobody = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moderator tools'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('GENERAL'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: Icon(Icons.history), // Add leading widget
            title: Text('Mod Log'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.stacked_line_chart), // Add leading widget
            title: Text('Insights'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.comments_disabled), // Add leading widget
            title: Text('community icon'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.edit), // Add leading widget
            title: Text('description'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.message), // Add leading widget
            title: Text('Welcome message'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.lock_reset), // Add leading widget
            title: Text('Community type'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.post_add), // Add leading widget
            title: Text('Post types'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.timer), // Add leading widget
            title: Text('Discovery Log'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.mail), // Add leading widget
            title: Text('Mod Mail'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.notification_add), // Add leading widget
            title: Text('Mod notifications'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.archive), // Add leading widget
            title: Text('Archived posts'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            title: Text('Content and regulations'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: Icon(Icons.queue), // Add leading widget
            title: Text('Queue'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.key), // Add leading widget
            title: Text('safety'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.crop_sharp), // Add leading widget
            title: Text('removal reason'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.rule), // Add leading widget
            title: Text('Rules'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.airplane_ticket), // Add leading widget
            title: Text('Post flair'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.alarm), // Add leading widget
            title: Text('schedueled post'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            title: Text('User management '),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: Icon(Icons.shield), // Add leading widget
            title: Text('Moderator'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.person), // Add leading widget
            title: Text('approved user'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.volume_mute_rounded), // Add leading widget
            title: Text('muted user'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.update_disabled_sharp), // Add leading widget
            title: Text('Banned user'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.airplane_ticket), // Add leading widget
            title: Text('User flair'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            title: Text('Resources LINKS'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: Icon(Icons.reddit), // Add leading widget
            title: Text('Sarakel for Community'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.help_center), // Add leading widget
            title: Text('Mod Help Center'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.rule_folder_sharp), // Add leading widget
            title: Text('Mod guidlines'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.support), // Add leading widget
            title: Text('r/ModSupport'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.help), // Add leading widget
            title: Text('r/Modhelp'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: Icon(Icons.reddit), // Add leading widget
            title: Text('contact sarakel'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
        ],
      ),
    );
  }
}
