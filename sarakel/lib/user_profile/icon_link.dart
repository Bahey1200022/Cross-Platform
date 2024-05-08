import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconLink extends StatefulWidget {
  final Future<String?> _urlsFuture;

  const IconLink({Key? key, required Future<String?> urlsFuture})
      : _urlsFuture = urlsFuture,
        super(key: key);

  @override
  IconLinkState createState() => IconLinkState();
}

class IconLinkState extends State<IconLink> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: widget._urlsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Handle the case when data is available
          final urls = snapshot.data ?? '';
          print(urls); // Get the URL or set an empty string if null
          return buildIcon(urls); // Build the icon based on the retrieved URL
        }
      },
    );
  }

  Widget buildIcon(String iconName) {
    Uri uri = Uri.parse(iconName);
    if (iconName.contains('facebook')) {
      return IconButton(
        icon: const Icon(Icons.facebook, color: Colors.white, size: 30),
        onPressed: () async {
          if (!await launchUrl(uri)) {
            throw Exception('Could not launch $iconName');
          }
        },
      );
    } else if (iconName.contains('reddit')) {
      return IconButton(
        icon: const Icon(
          Icons.reddit_rounded,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () async {
          if (!await launchUrl(uri)) {
            throw Exception('Could not launch $iconName');
          }
        },
      );
    } else if (iconName.contains('tiktok')) {
      return IconButton(
        icon: const Icon(
          Icons.tiktok,
          color: Colors.white,
        ),
        onPressed: () async {
          if (!await launchUrl(uri)) {
            throw Exception('Could not launch $iconName');
          }
        },
      );
    } else if (iconName.contains('twitter')) {
      return IconButton(
        icon: const FaIcon(
          FontAwesomeIcons.twitter,
          color: Colors.white,
        ),
        onPressed: () async {
          if (!await launchUrl(uri)) {
            throw Exception('Could not launch $iconName');
          }
        },
      );
    } else if (iconName.contains('soundcloud')) {
      return IconButton(
        icon: const FaIcon(
          FontAwesomeIcons.soundcloud,
          color: Colors.white,
        ),
        onPressed: () async {
          if (!await launchUrl(uri)) {
            throw Exception('Could not launch $iconName');
          }
        },
      );
    } else if (iconName.contains('youtube')) {
      return IconButton(
        icon: const FaIcon(
          FontAwesomeIcons.youtube,
          color: Colors.white,
        ),
        onPressed: () async {
          if (!await launchUrl(uri)) {
            throw Exception('Could not launch $iconName');
          }
        },
      );
    } else {
      return Container(); // Return an empty container if the iconName doesn't match
    }
  }
}
