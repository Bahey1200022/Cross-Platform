import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sarakel/user_profile/save_url.dart';

class UrlSheet extends StatelessWidget {
  final String? title;

  const UrlSheet({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment:
      //     MainAxisAlignment.center,
      children: [
        const Text('Add Social Link',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 150,
          endIndent: 150,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SaveUrl(
                        icon: Icon(Icons.facebook),
                        title: 'Facebook',
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.facebook,
                color: Colors.blue,
                size: 10,
              ),
              label: const Text(
                'Facebook',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(180, 255, 255, 255),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SaveUrl(
                        icon: Icon(
                          Icons.reddit_rounded,
                          color: Colors.orange,
                        ),
                        title: 'Reddit',
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.reddit_rounded,
                color: Colors.orange,
                size: 10,
              ),
              label: const Text(
                'Reddit',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(180, 255, 255, 255),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SaveUrl(
                        icon: Icon(
                          Icons.tiktok,
                          color: Colors.black,
                        ),
                        title: 'Tiktok',
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.tiktok,
                color: Colors.black,
                size: 10,
              ),
              label: const Text(
                'Tiktok',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(180, 255, 255, 255),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(
                      5), // Adjust this value to change the size of the button
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SaveUrl(
                        icon: FaIcon(FontAwesomeIcons.twitter,
                            color: Colors.blue),
                        title: 'Twitter',
                      ),
                    ),
                  ),
                );
                SaveUrl(
                  icon: FaIcon(FontAwesomeIcons.twitter, color: Colors.blue),
                  title: 'Twitter',
                );
              },
              icon: const FaIcon(FontAwesomeIcons.twitter,
                  color: Colors.blue, size: 10),
              label: const Text(
                'Twitter',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(180, 255, 255, 255),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SaveUrl(
                        icon: const FaIcon(
                          FontAwesomeIcons.soundcloud,
                          color: Colors.orange,
                          size: 10,
                        ),
                        title: 'SoundCloud',
                      ),
                    ),
                  ),
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.soundcloud,
                color: Colors.orange,
                size: 10,
              ),
              label: const Text(
                'SoundCloud',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(180, 255, 255, 255),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SaveUrl(
                        icon: const FaIcon(FontAwesomeIcons.youtube,
                            color: Colors.red, size: 10),
                        title: 'Youtube',
                      ),
                    ),
                  ),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.youtube,
                  color: Colors.red, size: 10),
              label: const Text(
                'Youtube',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(180, 255, 255, 255),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SaveUrl(
                        icon: const FaIcon(FontAwesomeIcons.link,
                            // color: Colors.red,
                            size: 15),
                        title: 'Custom Link',
                      ),
                    ),
                  ),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.link,
                  // color: Colors.red,
                  size: 15),
              label: const Text(
                'custom link',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(180, 255, 255, 255),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
