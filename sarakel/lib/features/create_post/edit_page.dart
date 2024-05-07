// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sarakel/features/create_post/edit_post.dart';

///edit post ui
// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  final String postid;

  const EditPage(this.postid);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _textEditingController;
  bool _isLoading = false;

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

  void _saveEditedContent() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      /// Simulate a delay for saving content
      Future.delayed(const Duration(seconds: 2), () {
        String editedContent = _textEditingController.text;
        /// Implement your logic to save the content here
        editpost(widget.postid, editedContent);

        setState(() {
          _isLoading = false;
        });

        /// Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Changes saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    } else {
      /// Show an error message if content is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some content to save'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  ///UI for editing a post
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
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveEditedContent,
                    child: const Text('Save'),
                  ),
          ],
        ),
      ),
    );
  }
}
