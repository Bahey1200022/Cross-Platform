import 'package:flutter/material.dart';

class SpoilerAlert extends StatelessWidget {
  final bool isSpoiler;
  const SpoilerAlert({super.key, required this.isSpoiler});

  @override
  Widget build(BuildContext context) {
    return isSpoiler
        ? Row(
            mainAxisSize:
                MainAxisSize.min, // Ensures the Row only takes up needed space
            children: const [
              Icon(Icons.warning,
                  size: 18, color: Colors.black), // Spoiler icon
              SizedBox(width: 4), // Spacing between icon and text
              Text('SPOILER',
                  style: TextStyle(fontSize: 12, color: Colors.black)),
            ],
          )
        : const SizedBox(); // Returns an empty SizedBox if isSpoiler is false
  }
}
