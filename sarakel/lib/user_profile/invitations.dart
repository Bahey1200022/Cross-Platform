import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/profiles/communityprofile_page.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/user_profile/getInvitations.dart';
import 'package:shared_preferences/shared_preferences.dart';

///showcase moderator and member invitations
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
            trailing: Row(
              mainAxisSize: MainAxisSize
                  .min, // set to min to take as little space as possible
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () {
                    if (invitations[index]['type'] ==
                        'You are invited to be a moderator') {
                      respond(invitations[index]['name'], "moderation",
                          "accept", context);
                    } else {
                      respond(invitations[index]['name'], "member", "accept",
                          context);
                    }
                    // Handle edit button press
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.thumb_down),
                  onPressed: () {
                    // Handle delete button press
                    if (invitations[index]['type'] ==
                        'You are invited to be a moderator') {
                      respond(invitations[index]['name'], "moderation",
                          "reject", context);
                    } else {
                      respond(invitations[index]['name'], "member", "reject",
                          context);
                    }
                  },
                ),
              ],
            ),
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
