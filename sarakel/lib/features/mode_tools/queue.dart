import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/removed_posts.dart';
import 'package:sarakel/features/mode_tools/reported_posts.dart';
import 'package:sarakel/models/community.dart';

class QueueBottomSheet extends StatelessWidget {
  final Community community;

  QueueBottomSheet({required this.community});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Queues',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 16.0),
          QueueButton(
            title: 'Needs Review',
            onTap: () {
              // Handle button tap
            },
          ),
          QueueButton(
            title: 'Removed',
            onTap: () {
              // Handle button tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RemovedPostsPage(community: community.name),
                ),
              );
            },
          ),
          QueueButton(
            title: 'Reported',
            onTap: () {
              // Handle button tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ReportedPostsPage(community: community.name),
                ),
              );
            },
          ),
          QueueButton(
            title: 'Edited',
            onTap: () {
              // Handle button tap
            },
          ),
          QueueButton(
            title: 'Unmoderated',
            onTap: () {
              // Handle button tap
            },
          ),
        ],
      ),
    );
  }
}

class QueueButton extends StatelessWidget {
  final String title;
  final Function()? onTap;

  const QueueButton({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
      trailing: Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }
}
