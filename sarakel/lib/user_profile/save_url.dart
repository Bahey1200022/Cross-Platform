import 'package:flutter/material.dart';
import 'package:sarakel/user_profile/user_controller.dart';
import 'package:sarakel/user_profile/user_profile.dart';
import 'package:sarakel/user_profile/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:sarakel/models/user.dart';

class SaveUrl extends StatefulWidget {
  final User? user;
  final Widget icon;
  final String? title;
  SaveUrl({Key? key, required this.icon, this.title, required this.user})
      : super(key: key);

  @override
  _SaveUrlState createState() => _SaveUrlState();
}

class _SaveUrlState extends State<SaveUrl> {
  final TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(user: widget.user!),
                ),
              );
            },
          ),
          const Center(
            child: Text('Add Social Link',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox.shrink(), // This is to take up the space at the end
        ],
      ),
      const Divider(
        color: Colors.grey,
      ),
      ElevatedButton.icon(
          icon: widget.icon, // default icon if none is provided
          label: Text(widget.title ??
              'Default Title'), // default title if none is provided
          onPressed: () {}
          // add functionality here
          ),
      TextField(
        controller: urlController,
        decoration: const InputDecoration(
          hintText: 'Enter URL',
          border: OutlineInputBorder(),
        ),
      ),
      ElevatedButton(
        child: const Text('Add'),
        onPressed: () {
          addSocialLink(urlController.text);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(user: widget.user!),
            ),
          );
        },
      ),
    ]);
  }
}
