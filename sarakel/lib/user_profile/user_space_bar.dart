import 'package:flutter/material.dart';
import 'package:sarakel/models/user.dart';
import 'package:sarakel/user_profile/edit%20_pi.dart';
import 'package:sarakel/user_profile/get_userpic.dart';
import 'package:sarakel/user_profile/new_chat.dart';
import 'package:sarakel/user_profile/user_visibility.dart';
import 'package:sarakel/user_profile/url_sheet.dart';

class UserSpaceBar extends StatefulWidget {
  final User? user;
  const UserSpaceBar({Key? key, this.user});

  @override
  State<UserSpaceBar> createState() {
    return _UserSpaceBarState();
  }
}

class _UserSpaceBarState extends State<UserSpaceBar> {
  bool loggeduserIconIsVisible = false;

  @override
  void initState() {
    super.initState();

    initializeVisibility();
    checkpic();
  }

  void initializeVisibility() async {
    loggeduserIconIsVisible = await isLoggedInUser(widget.user!.username!);
  }

  void checkpic() async {
    String photo = await getPicUrl(widget.user!.username!);
    setState(() {
      widget.user?.photoUrl = photo;
    });
    print('hii');
    print(widget.user?.photoUrl);
  }

  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(5, 17, 114, 0.878),
                    Color.fromARGB(255, 0, 0, 0),
                  ],
                ),
              ),
            ),
            // Additional widgets on the background
            Positioned(
              top: 50,
              left: 20,
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(50), // Image radius
                  child: widget.user?.photoUrl != null
                      ? Image.network(
                          widget.user!.photoUrl!,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          'assets/avatar_logo.jpeg',
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ),

            Positioned(
              top: 170,
              left: 20,
              child: Visibility(
                visible: loggeduserIconIsVisible,
                child: OutlinedButton(
                  onPressed: () {
                    editPic();
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 170,
              left: 20,
              child: Visibility(
                visible: !loggeduserIconIsVisible,
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'follow',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        newChat(widget.user!.username!, context);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.message_outlined,
                        color: Colors.white,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 210,
              left: 20,
              child: Text(
                widget.user!.username!,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Raleway',
                  fontSize: 25,
                ),
              ),
            ),
            Positioned(
              top: 250,
              left: 20,
              child: InkWell(
                onTap: () {
                  // Action code when the icon is clicked
                },
                child: const Row(
                  children: [
                    Text(
                      '# followers  ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                      size: 10,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 300,
              left: 20,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: UrlSheet(),
                        // Column(
                        //   // mainAxisAlignment:
                        //   //     MainAxisAlignment.center,
                        //   children: [
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         ElevatedButton.icon(
                        //           onPressed: () {},
                        //           icon: const Icon(
                        //             Icons.facebook,
                        //             color: Colors.blue,
                        //             size: 15,
                        //           ),
                        //           label: const Text(
                        //             'Facebook',
                        //             style: TextStyle(
                        //                 color: Colors.black,
                        //                 fontSize: 15,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //           style: ButtonStyle(
                        //             backgroundColor:
                        //                 MaterialStateProperty.all<Color>(
                        //               Color.fromARGB(180, 255, 255, 255),
                        //             ),
                        //           ),
                        //         ),
                        //         ElevatedButton.icon(
                        //           onPressed: () {},
                        //           icon: const Icon(
                        //             Icons.reddit_rounded,
                        //             color: Colors.orange,
                        //             size: 15,
                        //           ),
                        //           label: const Text(
                        //             'Reddit',
                        //             style: TextStyle(
                        //                 color: Colors.black,
                        //                 fontSize: 15,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //           style: ButtonStyle(
                        //             backgroundColor:
                        //                 MaterialStateProperty.all<Color>(
                        //               Color.fromARGB(180, 255, 255, 255),
                        //             ),
                        //           ),
                        //         ),
                        //         ElevatedButton.icon(
                        //           onPressed: () {},
                        //           icon: const Icon(
                        //             Icons.tiktok,
                        //             color: Colors.black,
                        //             size: 15,
                        //           ),
                        //           label: const Text(
                        //             'Tiktok',
                        //             style: TextStyle(
                        //                 color: Colors.black,
                        //                 fontSize: 15,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //           style: ButtonStyle(
                        //             backgroundColor:
                        //                 MaterialStateProperty.all<Color>(
                        //               Color.fromARGB(180, 255, 255, 255),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     SizedBox(height: 20),
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         ElevatedButton.icon(
                        //           onPressed: () {},
                        //           icon: FaIcon(FontAwesomeIcons.twitter,
                        //               color: Colors.blue, size: 15),
                        //           // icon: const Icon(
                        //           //   Icons.facebook,
                        //           //   color: Colors.blue,
                        //           //   size: 15,
                        //           // ),
                        //           label: const Text(
                        //             'Twitter',
                        //             style: TextStyle(
                        //                 color: Colors.black,
                        //                 fontSize: 15,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //           style: ButtonStyle(
                        //             backgroundColor:
                        //                 MaterialStateProperty.all<Color>(
                        //               Color.fromARGB(180, 255, 255, 255),
                        //             ),
                        //           ),
                        //         ),
                        //         ElevatedButton.icon(
                        //           onPressed: () {},
                        //           icon: FaIcon(FontAwesomeIcons.soundcloud,
                        //               color: Colors.orange, size: 15),
                        //           label: const Text(
                        //             'SoundCloud',
                        //             style: TextStyle(
                        //                 color: Colors.black,
                        //                 fontSize: 15,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //           style: ButtonStyle(
                        //             backgroundColor:
                        //                 MaterialStateProperty.all<Color>(
                        //               Color.fromARGB(180, 255, 255, 255),
                        //             ),
                        //           ),
                        //         ),
                        //         ElevatedButton.icon(
                        //           onPressed: () {},
                        //           icon: FaIcon(FontAwesomeIcons.youtube,
                        //               color: Colors.red, size: 15),
                        //           label: const Text(
                        //             'Youtube',
                        //             style: TextStyle(
                        //                 color: Colors.black,
                        //                 fontSize: 15,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //           style: ButtonStyle(
                        //             backgroundColor:
                        //                 MaterialStateProperty.all<Color>(
                        //               Color.fromARGB(180, 255, 255, 255),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     SizedBox(height: 20),
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //       children: [
                        //         ElevatedButton.icon(
                        //           onPressed: () {},
                        //           icon: FaIcon(FontAwesomeIcons.link,
                        //               // color: Colors.red,
                        //               size: 15),
                        //           label: const Text(
                        //             'custom link',
                        //             style: TextStyle(
                        //                 color: Colors.black,
                        //                 fontSize: 15,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //           style: ButtonStyle(
                        //             backgroundColor:
                        //                 MaterialStateProperty.all<Color>(
                        //               Color.fromARGB(180, 255, 255, 255),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ),
                    ),
                  );

                  // Your action when the button is clicked
                },
                label: const Text(
                  'Add social link',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 37, 37, 37),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
