import 'package:flutter/material.dart';

class AddModeratorPage extends StatelessWidget {
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
            TextFieldWithLabel(),
            SizedBox(height: 16),
            ModeratorPermissions(),
            SizedBox(height: 16),
            Expanded(
              // Expanded added here
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: AddButton(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldWithLabel extends StatefulWidget {
  @override
  _TextFieldWithLabelState createState() => _TextFieldWithLabelState();
}

class _TextFieldWithLabelState extends State<TextFieldWithLabel> {
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ModeratorPermissions extends StatefulWidget {
  @override
  _ModeratorPermissionsState createState() => _ModeratorPermissionsState();
}

class _ModeratorPermissionsState extends State<ModeratorPermissions> {
  bool _fullPermissions = false;

  List<bool> _permissions = List.filled(8, false); // Initialize with false

  @override
  Widget build(BuildContext context) {
    return Column(
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

class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Perform action when the button is pressed
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Color(0xFF00BFA5),
          padding: EdgeInsets.symmetric(vertical: 16.0),
          shape: StadiumBorder(), // Oval shape
        ),
        child: Text('Add'),
      ),
    );
  }
}
