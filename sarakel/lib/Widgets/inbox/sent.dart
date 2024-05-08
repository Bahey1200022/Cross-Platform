// ignore_for_file: camel_case_types, avoid_print, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/Widgets/drawers/community_drawer/community_list.dart';
import 'package:sarakel/Widgets/drawers/profile_drawer.dart';
import 'package:sarakel/Widgets/home/widgets/app_bar.dart';
import 'package:sarakel/Widgets/inbox/chat_card.dart';
import 'package:sarakel/constants.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/models/user.dart';
import 'package:sarakel/user_profile/get_userpic.dart';

///email message like class where it displays sent messages of the user
class sent extends StatefulWidget {
  final String token;
  User user;
  sent({super.key, required this.token, required this.user});

  @override
  State<sent> createState() => _sentState();
}

class _sentState extends State<sent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List messageCard = [];
  Future<void> initiatesentCard() async {
    // Make an HTTP request to the API
    var response = await http.get(Uri.parse('$BASE_URL/api/message/sent'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json'
        });

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the response data
      final jsonData = json.decode(response.body);
      print(jsonData[0]['_id']);

      // Update the messageCard list with the response data
      setState(() {
        messageCard = jsonData.reversed.toList();
      });
    } else {
      // Handle the error case
    }
  }

  @override
  void initState() {
    super.initState();
    initiatesentCard();
    getUserPic();
  }

  Future<void> getUserPic() async {
    String username = JwtDecoder.decode(widget.token)['username'];
    String picUrl = await getPicUrl(username);
    setState(() {
      widget.user.photoUrl = picUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(widget.token);

    return Scaffold(
      key: _scaffoldKey, // Assign key here
      appBar: CustomAppBar(
        title: 'Sent Messages',
        scaffoldKey: _scaffoldKey, // Pass the GlobalKey to the CustomAppBar
        photo: widget.user.photoUrl,
      ),
      drawer: CommunityDrawer(token: widget.token),
      endDrawer: ProfileDrawer(
        user: User(username: jwtdecodedtoken['username'], token: widget.token),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: messageCard.isNotEmpty ? messageCard.length : 0,
            itemBuilder: (context, index) {
              return ButtonCard(
                sender: messageCard[index]['username'],
                receiver: messageCard[index]['recipient'],
                id: messageCard[index]["_id"],
                token: widget.token,
                status: messageCard[index]['status'],
                icon: const Icon(Icons.person),
                live: false,
                title: messageCard[index]['title'],
                content: messageCard[index]['content'],
                sent: true,
              );
            },
          ),
        ),
      ]),
    );
  }
}
