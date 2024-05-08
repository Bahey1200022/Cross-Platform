import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/user_management/muted/add_muted_users_controller.dart';

class MuteUserPage extends StatefulWidget {
  final String communityName;
  final String token;

  const MuteUserPage({
    Key? key,
    required this.communityName,
    required this.token,
  }) : super(key: key);

  @override
  _MuteUserPageState createState() => _MuteUserPageState();
}

class _MuteUserPageState extends State<MuteUserPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Mute User',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _controller,
                  onChanged: (value) {
                    setState(() {
                      _isFocused = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter username',
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    errorText: _isFocused && _controller.text.isEmpty
                        ? 'Username is required'
                        : null,
                    suffixIcon: const Icon(Icons.person),
                  ),
                ),
              ],
            ),
            Spacer(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final String username = _controller.text.trim();
                  muteUser(widget.token, username, widget.communityName)
                      .then((muttedUser) {
                    if (muttedUser) {
                      // Mutted user successfully
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Mutted user successfully')),
                      );
                    } else {
                      // Mutted user failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to mute the user')),
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF00BFA5),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: const StadiumBorder(), // Oval shape
                ),
                child: const Text('Mute'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
