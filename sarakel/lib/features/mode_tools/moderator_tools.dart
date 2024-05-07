import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/general/edit-pic.dart';
import 'package:sarakel/features/mode_tools/general/notifications.dart';
import 'package:sarakel/features/mode_tools/modq/queue.dart';
import 'package:sarakel/features/mode_tools/quit_moderation_bottom_sheet.dart';
import 'package:sarakel/features/mode_tools/user_management/approved/approved_users.dart';
import 'package:sarakel/features/mode_tools/user_management/banned/banned_users.dart';
import 'package:sarakel/features/mode_tools/user_management/moderators/moderators_page.dart';
import 'package:sarakel/features/mode_tools/user_management/muted/muted_users.dart';
import 'package:sarakel/models/community.dart';

class ModeratorTools extends StatelessWidget {
  final String token;
  final Community community;

  const ModeratorTools({
    super.key,
    required this.token,
    required this.community,
  });

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
            leading: const Icon(Icons.image), // Add leading widget
            title: const Text('Edit community Picture'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
              editDisplayPic(community.name, token);
            },
          ),
          ListTile(
            leading: const Icon(Icons.image_outlined), // Add leading widget
            title: const Text('Edit background Picture'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to Mod Log page
              editBackgroundPic(community.name, token);
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
              disableNotification(context);
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
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return QueueBottomSheet(community: community.name);
                },
              );
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
            title: const Text('Moderators'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModeratorsPage(
                    token: token,
                    communityName: community.name,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person), // Add leading widget
            title: const Text('Approved users'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ApprovedUsersPage(),
                ),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.volume_mute_rounded), // Add leading widget
            title: const Text('Muted users'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MutedUsersPage(
                    token: token,
                    communityName: community.name,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.update_disabled_sharp), // Add leading widget
            title: const Text('Banned users'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BannedUsersPage(
                    token: token,
                    communityName: community.name,
                  ),
                ),
              );
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
          ListTile(
            tileColor: Colors.grey[200], // Set tile color to light grey
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            textColor: Colors.red, // Add leading widget
            title: Text('Quit moderation of c/${community.name}'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return QuitModerationBottomSheet(
                    token: token,
                    communityName: community.name,
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
