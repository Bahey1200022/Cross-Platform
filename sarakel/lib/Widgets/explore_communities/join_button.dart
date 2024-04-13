import 'package:flutter/material.dart';

class JoinButton extends StatefulWidget {
  final VoidCallback onPressed;

  JoinButton({required this.onPressed});

  @override
  _JoinButtonState createState() => _JoinButtonState();
}

class _JoinButtonState extends State<JoinButton> {
  bool _joined = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Toggle the join status and call the onPressed callback
        setState(() {
          _joined = !_joined;
        });
        widget.onPressed();
        // Show a snackbar to inform the user about the join status
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_joined ? 'Joined successfully' : 'Left community'),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          _joined
              ? Colors.white
              : Colors.blue, // Set background color to white when joined
        ),
        shape: MaterialStateProperty.all(
          StadiumBorder(), // Set shape to oval (stadium)
        ),
      ),
      child: Text(
        _joined ? 'Joined' : 'Join',
        style: TextStyle(
          color: _joined
              ? Colors.blue
              : Colors.white, // Set text color to blue when joined
        ),
      ),
    );
  }
}
