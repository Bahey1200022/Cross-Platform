import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/drawers/community_drawer/list_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/community.dart';
import 'add_post_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'dart:async';

class CreatePost extends StatefulWidget {
  final String token;

  const CreatePost({required this.token});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class MyAppState with ChangeNotifier {
  List<Community>? communities = [];
}

class _MyHomePageState extends State<CreatePost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  MyAppState appState = MyAppState();
  AddPostController addPostController = AddPostController();
  File? _image;
  bool isTitleEmpty = true;
  bool isUrlVisible = false;

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

  void toggleUrlVisibility() {
    setState(() {
      isUrlVisible = !isUrlVisible;
    });
  }

  void clearUrl() {
    setState(() {
      urlController.clear();
      isUrlVisible = false;
    });
  }

  Future<void> _getImage() async {
    final completer = Completer<File>();

    final html.InputElement input = html.InputElement()
      ..type = 'file'
      ..accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        final imageDataUrl = reader.result as String?;
        completer.complete(File(imageDataUrl!));
      });
    });

    final selectedImage = await completer.future;
    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });
    }
  }

  void _showCommunityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Community'),
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
          title: const Text('Post Confirmation'),
          content: Text('Do you want to post to ${selectedCommunity.name}?'),
          actions: [
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString('token');
                if (token == null) {
                  return;
                }
                // Handle posting
                Navigator.of(context).pop();
                final String title = titleController.text;
                final String body = bodyController.text;
                addPostController.addPost(
                    selectedCommunity.name,
                    selectedCommunity.id,
                    title,
                    body,
                    token,
                    urlController.text);
                //Navigator.pushNamed(context, '/home');
              },
              child: const Text('Post'),
            ),
            TextButton(
              onPressed: () {
                // Handle cancel
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const SizedBox.shrink(),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: (titleController.text.trim().isNotEmpty)
                ? () {
                    _showCommunityDialog();
                  }
                : null,
            style: TextButton.styleFrom(
              backgroundColor: (titleController.text.trim().isNotEmpty)
                  ? Colors.blue.withOpacity(0.7)
                  : Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  cursorColor: Colors.black,
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (value) {
                    setState(() {
                      isTitleEmpty = value.isEmpty;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                if (_image != null)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 200.0,
                        width: 200.0,
                        child: Image.network(_image!.path, fit: BoxFit.contain),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close_rounded),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8.0),
                if (isUrlVisible)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: urlController,
                          decoration: const InputDecoration(
                            hintText: 'URL',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: clearUrl,
                      ),
                    ],
                  ),
                const SizedBox(height: 8.0),
                TextField(
                  cursorColor: Colors.black,
                  controller: bodyController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'body text (optional)',
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.end, // Align icons at the bottom
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.link),
                    onPressed: toggleUrlVisibility,
                  ),
                  IconButton(
                    icon: Icon(Icons.image_outlined),
                    onPressed: () {
                      _getImage();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
