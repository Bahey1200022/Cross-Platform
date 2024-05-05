import 'package:flutter/material.dart';
import 'package:sarakel/features/create_post/edit_post.dart';

///edit post ui
// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  String postid;

  EditPage(this.postid);
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Edit Content',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save the edited content
                String editedContent = _textEditingController.text;
                // Implement your logic to save the content here
                editpost(widget.postid, editedContent);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
