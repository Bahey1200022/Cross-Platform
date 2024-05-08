import 'package:flutter/material.dart';
import 'package:sarakel/features/mode_tools/user_management/moderators/moderators_service.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/models/user.dart';
import 'package:sarakel/user_profile/user_profile.dart';

///Community Info Page
class InfoCommunity extends StatefulWidget {
  final Community community;
  final String token;

  const InfoCommunity(
      {super.key, required this.community, required this.token});

  @override
  State<InfoCommunity> createState() => _InfoCommunityState();
}

class _InfoCommunityState extends State<InfoCommunity> {
  List<String> moderators = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getModerators();
  }

  ///Get Moderators of the community
  void getModerators() {
    ModerationService.getModerators(widget.token, widget.community.name)
        .then((value) {
      setState(() {
        moderators = value;
        isLoading = false;
      });
    });
  }

  //Page UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Material(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Material(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20.0),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                showSearch(context: context, delegate: sarakelSearch());
              },
            ),
          ),
          Material(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20.0),
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {},
            ),
          ),
          Material(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20.0),
            child: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
        flexibleSpace: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.community.backimage ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'c/${widget.community.name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text('Description'),
                  subtitle: Text(widget.community.description),
                ),
                ListTile(
                  title: const Text('Rules'),
                  subtitle: Text(widget.community.rules.toString()),
                ),
                const ListTile(
                  title: Text('Moderators'),
                ),
                Expanded(
                  child: moderators.isEmpty
                      ? const Center(child: Text('No Moderators Found'))
                      : ListView.builder(
                          itemCount: moderators.length,
                          itemBuilder: (context, index) {
                            final member = moderators[index];
                            return Card(
                              child: ListTile(
                                title: Text('u/$member'),
                                onTap: () {
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
                ),
              ],
            ),
    );
  }
}
