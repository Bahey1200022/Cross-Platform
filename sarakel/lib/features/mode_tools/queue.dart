import 'package:flutter/material.dart';

class QueueBottomSheet extends StatelessWidget {
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
          QueueButton(title: 'Needs Review'),
          QueueButton(title: 'Removed'),
          QueueButton(title: 'Reported'),
          QueueButton(title: 'Edited'),
          QueueButton(title: 'Unmoderated'),
        ],
      ),
    );
  }
}

class QueueButton extends StatelessWidget {
  final String title;

  const QueueButton({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
      //trailing: Icon(Icons.arrow_forward),
      onTap: () {
        // Handle button tap
      },
    );
  }
}
