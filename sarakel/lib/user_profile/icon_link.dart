import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sarakel/user_profile/user_controller.dart';

// class IconLink extends StatefulWidget {
//   const IconLink({Key? key}) : super(key: key);

//   @override
//   IconLinkState createState() => IconLinkState();
// }

// class IconLinkState extends State<IconLink> {
//   late Future<String?> _urlsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _urlsFuture = getUserUrl();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String?>(
//       future: _urlsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator(); // Show loading indicator while fetching data
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           final urls =
//               snapshot.data ?? ''; // Get the URL or set an empty string if null
//           return IconButton(
//             onPressed: () {},
//             icon: buildIcon(urls),
//           );
//         }
//       },
//     );
//   }

//   Widget buildIcon(String iconName) {
//     if (iconName.contains('facebook')) {
//       return Icon(
//         Icons.facebook,
//         color: Colors.white,
//       );
//     } else if (iconName.contains('reddit')) {
//       return const Icon(
//         Icons.reddit_rounded,
//         color: Colors.white,
//       );
//     } else if (iconName.contains('tiktok')) {
//       return const Icon(
//         Icons.tiktok,
//         color: Colors.white,
//       );
//     } else if (iconName.contains('twitter')) {
//       return const FaIcon(
//         FontAwesomeIcons.twitter,
//         color: Colors.white,
//       );
//     } else if (iconName.contains('SoundCloud')) {
//       return const FaIcon(
//         FontAwesomeIcons.soundcloud,
//         color: Colors.white,
//       );
//     } else if (iconName.contains('youtube')) {
//       return const FaIcon(
//         FontAwesomeIcons.youtube,
//         color: Colors.white,
//         size: 10,
//       );
//     } else {
//       return Container();
//     }
//   }
// }

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
          final urls =
              snapshot.data ?? ''; // Get the URL or set an empty string if null
          return buildIcon(urls); // Build the icon based on the retrieved URL
        }
      },
    );
  }

  Widget buildIcon(String iconName) {
    if (iconName.contains('facebook')) {
      return Icon(
        Icons.facebook,
        color: Colors.white,
      );
    } else if (iconName.contains('reddit')) {
      return const Icon(
        Icons.reddit_rounded,
        color: Colors.white,
        size: 30,
      );
    } else if (iconName.contains('tiktok')) {
      return const Icon(
        Icons.tiktok,
        color: Colors.white,
      );
    } else if (iconName.contains('twitter')) {
      return const FaIcon(
        FontAwesomeIcons.twitter,
        color: Colors.white,
      );
    } else if (iconName.contains('soundcloud')) {
      return const FaIcon(
        FontAwesomeIcons.soundcloud,
        color: Colors.white,
      );
    } else if (iconName.contains('youtube')) {
      return const FaIcon(
        FontAwesomeIcons.youtube,
        color: Colors.white,
      );
    } else {
      return Container(); // Return an empty container if the iconName doesn't match
    }
  }
}



// class IconLink extends StatefulWidget {
//   IconLink({Key? key}) : super(key: key);

//   @override
//   IconLinkState createState() => IconLinkState();
// }

// class IconLinkState extends State<IconLink> {
//   String urls = '';

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () async {
//         print('----------------------------------------');

//         urls = await getUserUrl();

//         print('in icon link');
//         print(urls);

//         setState(() {}); // Update the state to trigger a rebuild
//       },
//       icon: buildIcon(urls),
//     );
//   }

//   Widget buildIcon(String iconName) {
//     // Initialize the search string here

//     // Add your logic to search for the string
//     if (iconName.contains('facebook')) {
//       // Do something if the string is found
//       return Icon(
//         Icons.facebook,
//         color: Colors.white,
//         // Add any additional properties for the icon here
//       );
//     } else if (iconName.contains('reddit')) {
//       // Do something if the string is found
//       return const Icon(
//         Icons.reddit_rounded,
//         color: Colors.white,

//         // Add any additional properties for the icon here
//       );
//     } else if (iconName.contains('tiktok')) {
//       // Do something if the string is found
//       return const Icon(
//         Icons.tiktok,
//         color: Colors.white,

//         // Add any additional properties for the icon here
//       );
//     } else if (iconName.contains('twitter')) {
//       // Do something if the string is found
//       return const FaIcon(
//         FontAwesomeIcons.twitter,
//         color: Colors.white,
//       );
//       // Add any additional properties for the icon her
//     } else if (iconName.contains('SoundCloud')) {
//       // Do something if the string is found
//       return const FaIcon(
//         FontAwesomeIcons.soundcloud,
//         color: Colors.white,
//       );
//     } else if (iconName.contains('tiktok')) {
//       // Do something if the string is found
//       return const Icon(
//         Icons.tiktok,
//         color: Colors.white,

//         // Add any additional properties for the icon here
//       );
//     } else if (iconName.contains('youtube')) {
//       // Do something if the string is found
//       return const FaIcon(FontAwesomeIcons.youtube,
//           color: Colors.white, size: 10);
//     } else {
//       // Do something if the string is not found
//       return Container();
//     }
//   }
// }
