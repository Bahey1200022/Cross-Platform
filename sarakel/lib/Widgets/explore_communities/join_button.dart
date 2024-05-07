// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

///join button class
class JoinButton extends StatefulWidget {
  final bool isJoined;
  final VoidCallback onPressed;

  const JoinButton(
      {super.key, required this.isJoined, required this.onPressed});

  @override
  _JoinButtonState createState() => _JoinButtonState();
}

class _JoinButtonState extends State<JoinButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (widget.isJoined) {
          // Open bottom drawer to confirm leaving community
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return LeaveCommunityBottomSheet(onLeave: widget.onPressed);
            },
          );
        } else {
          widget.onPressed();
          // Show a snack bar to inform the user about the join status
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  widget.isJoined ? 'Left community' : 'Joined successfully'),
            ),
          );
        }
      },
      style: ButtonStyle(
        backgroundColor: widget.isJoined
            ? MaterialStateProperty.all(Colors.white)
            : MaterialStateProperty.all(Colors.blue),
        shape: MaterialStateProperty.all(
          const StadiumBorder(), // Oval shape
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Text(
          widget.isJoined ? 'Joined' : 'Join',
          style: TextStyle(
            color: widget.isJoined ? Colors.blue : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class LeaveCommunityBottomSheet extends StatelessWidget {
  final VoidCallback onLeave;

  const LeaveCommunityBottomSheet({super.key, required this.onLeave});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ensure the bottom sheet occupies full width
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              onLeave();
              // Show a snack bar to inform the user about leaving the community
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Left community'),
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app), // Add icon for leave
            label: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}
