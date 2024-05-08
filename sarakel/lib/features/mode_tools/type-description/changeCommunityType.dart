// ignore_for_file: library_private_types_in_public_api, file_names, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

/// A page to change the type of a community.
class ChangeCommunityTypePage extends StatefulWidget {
  final String token;
  final String communityName;
  final String type;

  const ChangeCommunityTypePage({
    super.key,
    required this.token,
    required this.communityName,
    required this.type,
  });

  @override
  _ChangeCommunityTypePageState createState() => _ChangeCommunityTypePageState();
}

class _ChangeCommunityTypePageState extends State<ChangeCommunityTypePage> {
  late double diffLevel;

  @override
  void initState() {
    super.initState();
    diffLevel = _getTypeValue(widget.type);
  }

Future<void> _changeCommunityType(double newType) async {
  // Determine the type based on the slider value
  String type;
  if (newType == 0) {
    type = 'public';
  } else if (newType == 1) {
    type = 'restricted';
  } else {
    type = 'private';
  }

  final url = '$BASE_URL/api/r/${widget.communityName}/edit_community';
  final response = await http.patch(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    },
    body: jsonEncode({
      'communityName': widget.communityName,
      'type': type,
    }),
  );

  if (response.statusCode == 200) {
    print('Successfully changed community type to $type ${response.body}');
  } else {
    print('Failed to change community type. Error: ${response.body}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Community Type'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _changeCommunityType(diffLevel);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Slider.adaptive(
                  value: diffLevel,
                  onChanged: (double value) {
                    setState(() {
                      diffLevel = value;
                    });
                  },
                  min: 0,
                  max: 2,
                  divisions: 2,
                  activeColor: _getSliderColor(diffLevel),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _getTypeLabel(diffLevel),
                        style: TextStyle(
                          color: _getSliderColor(diffLevel),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Flexible(
                          child: Text(
                            _getTypeDescription(diffLevel),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '18+ Community ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Switch(
                      activeColor: Colors.blue,
                      value: true, // replace with your variable
                      onChanged: (bool value) {
                        // handle switch state change
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSliderColor(double diffLevel) {
    if (diffLevel == 0) {
      return Colors.green;
    } else if (diffLevel == 1) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String _getTypeLabel(double diffLevel) {
    if (diffLevel == 0) {
      return 'public';
    } else if (diffLevel == 1) {
      return 'restricted';
    } else {
      return 'private';
    }
  }

  String _getTypeDescription(double diffLevel) {
    if (diffLevel == 0) {
      return 'Anyone can see and participate in the community';
    } else if (diffLevel == 1) {
      return 'Anyone can see, join, or vote in the community, but you control who posts and comments';
    } else {
      return 'Only people you approve can see and participate in this community';
    }
  }

 double _getTypeValue(String type) {
    switch (type) {
      case 'public':
        return 0;
      case 'restricted':
        return 1;
      case 'private':
        return 2;
      default:
        return 1; // Default to restricted if type is not recognized    }
  }
}
}