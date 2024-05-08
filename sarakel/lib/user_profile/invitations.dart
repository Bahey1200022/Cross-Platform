import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/profiles/communityprofile_page.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/user_profile/getInvitations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Invitations extends StatefulWidget {
  final String username;

  Invitations({Key? key, required this.username}) : super(key: key);

  @override
  _InvitationsState createState() => _InvitationsState();
}

class _InvitationsState extends State<Invitations> {
  List<Map<String, dynamic>> invitations = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInvitations().then((value) {
      setState(() {
        invitations = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitations for ${widget.username}'),
      ),
      body: ListView.builder(
        itemCount: invitations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(invitations[index]['name']),
            subtitle: Text('${invitations[index]['type']}'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var token = prefs.getString('token');
              Community community = await getInfo(invitations[index]['name']);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) {
                  return CommunityProfilePage(
                    community: community,
                    token: token!,
                  );
                }),
              );
            },
          );
        },
      ),
    );
  }
}
