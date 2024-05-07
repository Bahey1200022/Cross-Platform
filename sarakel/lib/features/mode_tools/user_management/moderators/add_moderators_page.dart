import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/user_management/moderators/add_moderator_controller.dart';

class AddModeratorPage extends StatefulWidget {
  final String communityName;
  final String token;

  const AddModeratorPage({
    Key? key,
    required this.communityName,
    required this.token,
  }) : super(key: key);

  @override
  _AddModeratorPageState createState() => _AddModeratorPageState();
}

class _AddModeratorPageState extends State<AddModeratorPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;
  bool _fullPermissions = true;
  List<bool> _permissions = List.filled(8, true); // Initialize with false

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add a moderator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  _isFocused = value.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter moderator username',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorText: _isFocused && _controller.text.isEmpty
                    ? 'Username is required'
                    : null,
                suffixIcon: Icon(Icons.person),
                labelText: _isFocused ? 'Username' : null,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _fullPermissions,
                      onChanged: (value) {
                        setState(() {
                          _fullPermissions = value!;
                          if (_fullPermissions) {
                            _permissions = List.filled(8, true);
                          } else {
                            _permissions = List.filled(8, false);
                          }
                        });
                      },
                    ),
                    Text('Full Permissions'),
                  ],
                ),
                ...List.generate(
                  _permissions.length,
                  (index) => Row(
                    children: [
                      Checkbox(
                        value: _permissions[index],
                        onChanged: (value) {
                          setState(() {
                            _permissions[index] = value!;
                          });
                        },
                      ),
                      Text('Manage ${_permissionText(index)}'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final String username = _controller.text.trim();
                  sendModeratorInvitation(
                          widget.token, username, widget.communityName)
                      .then((invitationSent) {
                    if (invitationSent) {
                      // Invitation sent successfully
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invitation sent successfully')),
                      );
                    } else {
                      // Invitation failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to send invitation')),
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF00BFA5),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: StadiumBorder(), // Oval shape
                ),
                child: Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _permissionText(int index) {
    switch (index) {
      case 0:
        return 'Users';
      case 1:
        return 'Modmail';
      case 2:
        return 'Config';
      case 3:
        return 'Posts & Comments';
      case 4:
        return 'Flair';
      case 5:
        return 'Wiki';
      case 6:
        return 'Chat Config';
      case 7:
        return 'Chat Operator';
      default:
        return '';
    }
  }
}
