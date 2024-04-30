import 'package:flutter/material.dart';
import '../../models/community.dart';

class CircleSelectionPage extends StatelessWidget {
  final List<Community>? communities;
  final Community? selectedCommunity; // Add selectedCommunity parameter

  const CircleSelectionPage(
      {super.key, this.communities, this.selectedCommunity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post to'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // Close the circle selection page
          },
        ),
      ),
      body: ListView.builder(
        itemCount: communities!.length,
        itemBuilder: (context, index) {
          final circle = communities![index];
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Row(
              children: [
                Text('c/${circle.name}'),
                const Spacer(),
                Icon(
                  circle == selectedCommunity
                      ? Icons.check_circle
                      : Icons.circle,
                  color: circle == selectedCommunity ? Colors.green : null,
                ),
              ],
            ),
            subtitle: Text(circle.description),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(circle.image),
            ),
            onTap: () {
              Navigator.pop(context, circle);
            },
          );
        },
      ),
    );
  }
}
