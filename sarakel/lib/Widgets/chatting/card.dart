import 'package:flutter/material.dart';

// Inside the ChatTile widget
class ChatTile extends StatelessWidget {
  final String person;
  final String content;
  final String profilePicture; // Add profile picture parameter
  final bool isSender;

  const ChatTile({super.key, 
    required this.person,
    required this.content,
    required this.profilePicture, // Initialize profile picture parameter
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isSender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start, // Align based on sender or receiver
        children: [
          if (!isSender) ...[
            CircleAvatar(
              backgroundImage:
                  AssetImage(profilePicture), // Display profile picture
              radius: 20.0,
            ),
            const SizedBox(width: 8.0),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: isSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment
                      .start, // Align text based on sender or receiver
              children: [
                Text(
                  person,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isSender
                        ? Colors.blue
                        : Colors.grey[
                            300], // Message bubble color based on sender or receiver
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    content,
                  ),
                ),
              ],
            ),
          ),
          if (isSender) ...[
            const SizedBox(width: 8.0),
            CircleAvatar(
              backgroundImage:
                  AssetImage(profilePicture), // Display profile picture
              radius: 20.0,
            ),
          ],
        ],
      ),
    );
  }
}
