import 'package:flutter/material.dart';

class JoinButton extends StatefulWidget {
  final bool isJoined;
  final VoidCallback onPressed;

  const JoinButton({Key? key, required this.isJoined, required this.onPressed})
      : super(key: key);

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
          StadiumBorder(), // Oval shape
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

  const LeaveCommunityBottomSheet({Key? key, required this.onLeave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Are you sure you want to leave the community?',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onLeave();
              // Show a snack bar to inform the user about leaving the community
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Left community'),
                ),
              );
            },
            child: Text('Leave'),
          ),
        ],
      ),
    );
  }
}
