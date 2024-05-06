import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/drawers/community_drawer/list_controller.dart';
import 'package:sarakel/Widgets/home/controllers/home_screen_controller.dart';
import 'package:sarakel/features/create_post/circle_selection.dart';
import 'package:sarakel/features/create_post/flairs_menu.dart';
import 'package:sarakel/features/create_post/vid.dart';
//import 'package:sarakel/Widgets/drawers/community_drawer/list_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../models/community.dart';
import 'add_post_controller.dart';
import 'dart:async';
import 'package:sarakel/Widgets/home/homescreen.dart';
import 'schedule_post.dart';
import 'package:image_picker/image_picker.dart';

class CreatePost extends StatefulWidget {
  final String token;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final Function(bool) onScheduled;

  const CreatePost({super.key, required this.token, required this.selectedDate, required this.selectedTime, required this.onScheduled});

  @override
  // ignore: library_private_types_in_public_api
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  List<Community>? communities = [];
  Community? selectedCommunity;
  AddPostController addPostController = AddPostController();
  File? _image;
  bool isTitleEmpty = true;
  bool isUrlVisible = false;
  bool isMenuOpen = false;
  bool isSpoiler = false;
  bool isNSFW = false;
  bool isBA = false;
  File? _video;
  Image? thumbnail;
  VideoPlayerController? _videoController;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isScheduled = false;
  

  @override
  void initState() {
    super.initState();
    loadCircles().then((fetchedCommunities) {
      setState(() {
        communities = fetchedCommunities;
      });
      _selectedDate = widget.selectedDate;
      _selectedTime = widget.selectedTime;
      //appState.communities = fetchedCommunities;
      // ignore: avoid_print
      print('Communities loaded: ${communities!.length}');
    });
    // _videoController = VideoPlayerController.file(File(_video!.path))
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized
    //     setState(() {});
    //   });
    // _videoController!.play();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController?.dispose();
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

  void _selectCircle(BuildContext context) async {
    final selectedCircle = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CircleSelectionPage(
                communities: communities,
                selectedCommunity: selectedCommunity,
              )),
    );
    if (selectedCircle != null) {
      setState(() {
        selectedCommunity = selectedCircle;
      });
    }
  }

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void updateSpoiler(bool isSpoiler) {
    setState(() {
      this.isSpoiler = isSpoiler;
    });
  }

  void updateNSFW(bool isNSFW) {
    setState(() {
      this.isNSFW = isNSFW;
    });
  }

  void updateBA(bool isBA) {
    setState(() {
      this.isBA = isBA;
    });
  }

  Future<void> _getVideo() async {
    final completer = Completer<File>();

    if (Platform.isAndroid) {
      // ...

      final pickedVideo =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedVideo != null) {
        completer.complete(File(pickedVideo.path));
      } else {
        completer.completeError('No video selected');
      }
    }

    final selectedVideo = await completer.future;
    _video = selectedVideo;

    Uint8List? thumbnaildata = await generateThumbnail(_video!.path);
    if (thumbnaildata != null) {
      thumbnail = Image.memory(thumbnaildata);
      // Use the thumbnail widget
    }
    setState(() {
      _video = selectedVideo;
    });
  }

  Future<void> _getImage() async {
    final completer = Completer<File>();

    if (Platform.isAndroid) {
      // ...

      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        completer.complete(File(pickedImage.path));
      } else {
        completer.completeError('No image selected');
      }
    }

    final selectedImage = await completer.future;
    setState(() {
      _image = selectedImage;
    });
  }

    void _schedulePost(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SchedulePostScreen(
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
          onScheduled: (isScheduled) {
            setState(() {
              _isScheduled = isScheduled;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _schedulePost(context);
            },
          ),
          TextButton(
            onPressed: () async {
              if (selectedCommunity != null) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString('token');
                if (token == null) {
                  return;
                }
                // Handle posting
                //Navigator.of(context).pop();
                final String title = titleController.text;
                final String body = bodyController.text;
                addPostController.addPost(
                    selectedCommunity!.name,
                    selectedCommunity!.id,
                    title,
                    body,
                    token,
                    urlController.text,
                    isSpoiler,
                    isNSFW,
                    isBA,
                    _image,
                    _video);
                Navigator.pushAndRemoveUntil(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                      builder: (context) => SarakelHomeScreen(
                          homescreenController:
                              HomescreenController(token: token))),
                  (route) => false,
                );
              } else {
                _selectCircle(context);
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: (titleController.text.trim().isNotEmpty)
                  ? Colors.blue.withOpacity(0.7)
                  : Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (selectedCommunity != null && _isScheduled==false) ? 'Post' : (_isScheduled == true) ? 'Schedule' : 'Next',
                style: const TextStyle(
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
                if (selectedCommunity != null)
                  ListTile(
                    title: Text("c/${selectedCommunity!.name}"),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(selectedCommunity!.image),
                    ),
                    onTap: () {
                      _selectCircle(context);
                    },
                    trailing: const Text('RULES',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                if (isSpoiler || isNSFW || isBA)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSpoiler)
                            const Row(
                              children: [
                                Icon(Icons.warning_amber_outlined,
                                    color: Colors.black),
                                SizedBox(width: 8.0),
                                Text(
                                  'Spoiler',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          if (isNSFW)
                            const Row(
                              children: [
                                Icon(Icons.no_adult_content_outlined,
                                    color: Colors.red),
                                SizedBox(width: 8.0),
                                Text(
                                  'NSFW',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          if (isBA)
                            const Row(
                              children: [
                                Icon(Icons.monetization_on_outlined,
                                    color: Colors.grey),
                                SizedBox(width: 8.0),
                                Text(
                                  'Brand Affiliate',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                TextField(
                  cursorColor: Colors.black,
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (value) {
                    setState(() {
                      isTitleEmpty = value.isEmpty;
                    });
                  },
                ),
                if (selectedCommunity != null)
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return FlairsMenu(
                                        onSpoilerChanged: updateSpoiler,
                                        onBAChanged: updateBA,
                                        onNSFWChanged: updateNSFW);
                                  });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  (titleController.text.trim().isNotEmpty)
                                      ? Colors.blueGrey[50]
                                      : Colors.grey.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                'Add tags and flairs (optional)',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8.0),
                if (_image != null || _video != null)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 200.0,
                        width: 200.0,
                        child: (_image != null)
                            ? Image(
                                image: FileImage(File(_image!.path)),
                                fit: BoxFit.contain,
                              )
                            : (_video != null)
                                ? thumbnail
                                : Container(),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _image = null;
                              _video = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded),
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
                  if (!isMenuOpen)
                    IconButton(
                      icon: const Icon(Icons.link),
                      onPressed: toggleUrlVisibility,
                    ),
                  if (!isMenuOpen)
                    IconButton(
                      icon: const Icon(Icons.image_outlined),
                      onPressed: () {
                        _getImage();
                      },
                    ),
                  if (!isMenuOpen)
                    IconButton(
                      icon: const Icon(Icons.videocam_outlined),
                      onPressed: () {
                        // Handle video upload
                        _getVideo();
                      },
                    ),
                  if (!isMenuOpen)
                    IconButton(
                      icon: const Icon(Icons.poll_outlined),
                      onPressed: () {
                        // Handle poll
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isMenuOpen
          ? IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              onPressed: toggleMenu,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_up),
                  onPressed: toggleMenu,
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: isMenuOpen ? _buildMenuIcons() : null,
    );
  }

  Widget _buildMenuIcons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'What do you want to add?',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.link),
                  onPressed: toggleUrlVisibility,
                ),
                const Text('Link'),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: () {
                    _getImage();
                  },
                ),
                const Text('Image'),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.videocam_outlined),
                  onPressed: () {
                    _getVideo();
                    // Handle video upload
                  },
                ),
                const Text('Video'),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.poll_outlined),
                  onPressed: () {
                    // Handle poll
                  },
                ),
                const Text('Poll'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
