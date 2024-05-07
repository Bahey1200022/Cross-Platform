import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/modq/umodereted.dart';

class QueueBottomSheet extends StatelessWidget {
  final String community;

  const QueueBottomSheet({super.key, required this.community});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Queues',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 16.0),
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
            },
          ),
          QueueButton(
            title: 'Reported',
            onTap: () {
              // Handle button tap
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Unmoderated(community: community)));
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
        style: const TextStyle(fontWeight: FontWeight.normal),
      ),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }
}
