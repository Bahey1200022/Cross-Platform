import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/user_management/moderators/moderators_service.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/models/user.dart';
import 'package:sarakel/user_profile/user_profile.dart';

class InfoCommunity extends StatefulWidget {
  final Community community;
  final String token;
  const InfoCommunity({Key? key, required this.community, required this.token})
      : super(key: key);

  @override
  State<InfoCommunity> createState() => _InfoCommunityState();
}

class _InfoCommunityState extends State<InfoCommunity> {
  List<String> moderators = [];
  @override
  void initState() {
    super.initState();
    getmoderators();
  }

  void getmoderators() {
    ModerationService.getModerators(widget.token, widget.community.name)
        .then((value) {
      setState(() {
        moderators = value;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 43, 126, 243),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                showSearch(context: context, delegate: sarakelSearch());
              },
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.community.backimage ?? ''),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text('Description'),
              subtitle: Text(widget.community.description),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Circles Rules'),
              subtitle:
                  Text(widget.community.rules ?? 'Sarakel under constructiom'),
            ),
          ),
          const Card(
            child: ListTile(
              title: Text('Moderators'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: moderators.length,
              itemBuilder: (context, index) {
                final member = moderators[index];
                return ListTile(
                  title: Text(member),
                  trailing: IconButton(
                    icon: const Icon(Icons.message),
                    onPressed: () {
                      // Perform delete operation for the moderator
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                            user: User(username: member),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
