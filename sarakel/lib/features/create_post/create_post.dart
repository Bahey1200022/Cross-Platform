import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:sarakel/Widgets/drawers/community_drawer/list_controller.dart';
import 'package:sarakel/providers/user_communities.dart';
import '../../models/community.dart';
import 'add_post_controller.dart';

class CreatePost extends StatefulWidget {
  final String token;

  const CreatePost({required this.token}); //

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class MyAppState with ChangeNotifier {
  List<Community>? communities = [];
}

class _MyHomePageState extends State<CreatePost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  List<File> attachments = [];
  MyAppState appState = MyAppState();
  AddPostController addPostController = AddPostController();

  @override
  void initState() {
    super.initState();
    loadCircles().then((fetchedCommunities) {
      appState.communities = fetchedCommunities;
      print('Communities loaded: ${appState.communities!.length}');
    });
    titleController.addListener(updateNextButtonState);
    bodyController.addListener(updateNextButtonState);
  }

  void updateNextButtonState() {
    setState(() {});
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          attachments.addAll(result.files.map((file) => File(file.path!)));
        });
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }

  void _openAttachmentDialog(File attachmentFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: _getAttachmentWidget(attachmentFile),
          ),
        );
      },
    );
  }

  Widget _getAttachmentWidget(File file) {
    Widget attachmentWidget;

    if (file.path.toLowerCase().endsWith('.jpg') ||
        file.path.toLowerCase().endsWith('.jpeg') ||
        file.path.toLowerCase().endsWith('.png')) {
      attachmentWidget = Image.file(
        file,
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
      );
    } else if (file.path.toLowerCase().endsWith('.mp4')) {
      attachmentWidget = Icon(Icons.play_circle, size: 100, color: Colors.blue);
    } else if (file.path.toLowerCase().endsWith('.pdf')) {
      attachmentWidget =
          Icon(Icons.picture_as_pdf, size: 100, color: Colors.red);
    } else {
      attachmentWidget = Icon(Icons.attach_file, size: 100, color: Colors.grey);
    }

    return attachmentWidget;
  }

  Widget _getFileWidget(File file) {
    return GestureDetector(
      onTap: () => _openAttachmentDialog(file),
      child: Card(
        elevation: 5.0,
        color: Colors.grey[200],
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getAttachmentWidget(file),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        _removeAttachment(attachments.indexOf(file)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Show community selection dialog
  void _showCommunityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Circle'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: appState.communities!
                  .map(
                    (community) => ListTile(
                      title: Text(community.name),
                      onTap: () {
                        // Handle community selection
                        print('Selected Community: ${community.name}');
                        Navigator.of(context).pop();
                        _showPostConfirmationDialog(community);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  void _showPostConfirmationDialog(Community selectedCommunity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Post Confirmation'),
          content: Text('Do you want to post to ${selectedCommunity.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                // Handle posting
                print('Post to ${selectedCommunity.name}');
                Navigator.of(context).pop();
                final String title = titleController.text;
                final String body = bodyController.text;
                addPostController.addPost(
                    selectedCommunity.name, selectedCommunity.id, title, body);
                Navigator.pushNamed(context, '/home');
              },
              child: Text('Post'),
            ),
            TextButton(
              onPressed: () {
                // Handle cancel
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        actions: [
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.orange),
            onPressed: _pickFiles,
          ),
          TextButton(
            onPressed: (titleController.text.trim().isNotEmpty &&
                    bodyController.text.trim().isNotEmpty)
                ? () {
                    // Show community selection dialog
                    _showCommunityDialog();
                  }
                : null,
            style: TextButton.styleFrom(
              backgroundColor: (titleController.text.trim().isNotEmpty &&
                      bodyController.text.trim().isNotEmpty)
                  ? Colors.orange.withOpacity(0.7)
                  : Colors.grey.withOpacity(0.5), // Shaded appearance
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: bodyController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(labelText: 'Body'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: attachments.length,
                itemBuilder: (context, index) {
                  return _getFileWidget(attachments[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
