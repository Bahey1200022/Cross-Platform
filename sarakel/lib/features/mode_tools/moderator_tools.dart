import 'package:flutter/material.dart';
import 'package:sarakel/models/community.dart';

class ModeratorTools extends StatefulWidget {
  final String token;
  final Community community;
  const ModeratorTools(
      {super.key, required this.token, required this.community});
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
        title: const Text('Moderator tools'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('GENERAL'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: const Icon(Icons.history), // Add leading widget
            title: const Text('Mod Log'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.stacked_line_chart), // Add leading widget
            title: const Text('Insights'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.comments_disabled), // Add leading widget
            title: const Text('community icon'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit), // Add leading widget
            title: const Text('description'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.message), // Add leading widget
            title: const Text('Welcome message'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_reset), // Add leading widget
            title: const Text('Community type'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.post_add), // Add leading widget
            title: const Text('Post types'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.timer), // Add leading widget
            title: const Text('Discovery Log'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail), // Add leading widget
            title: const Text('Mod Mail'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.notification_add), // Add leading widget
            title: const Text('Mod notifications'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive), // Add leading widget
            title: const Text('Archived posts'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            title: const Text('Content and regulations'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: const Icon(Icons.queue), // Add leading widget
            title: const Text('Queue'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.key), // Add leading widget
            title: const Text('safety'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.crop_sharp), // Add leading widget
            title: const Text('removal reason'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.rule), // Add leading widget
            title: const Text('Rules'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.airplane_ticket), // Add leading widget
            title: const Text('Post flair'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.alarm), // Add leading widget
            title: const Text('schedueled post'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            title: const Text('User management '),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: const Icon(Icons.shield), // Add leading widget
            title: const Text('Moderator'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.person), // Add leading widget
            title: const Text('approved user'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.volume_mute_rounded), // Add leading widget
            title: const Text('muted user'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.update_disabled_sharp), // Add leading widget
            title: const Text('Banned user'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.airplane_ticket), // Add leading widget
            title: const Text('User flair'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            title: const Text('Resources LINKS'),
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: const Icon(Icons.reddit), // Add leading widget
            title: const Text('Sarakel for Community'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_center), // Add leading widget
            title: const Text('Mod Help Center'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.rule_folder_sharp), // Add leading widget
            title: const Text('Mod guidlines'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.support), // Add leading widget
            title: const Text('r/ModSupport'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.help), // Add leading widget
            title: const Text('r/Modhelp'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
          ListTile(
            leading: const Icon(Icons.reddit), // Add leading widget
            title: const Text('contact sarakel'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
            },
          ),
        ],
      ),
    );
  }
}
