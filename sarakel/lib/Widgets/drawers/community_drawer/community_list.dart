// ignore_for_file: library_private_types_in_public_api, unused_import, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sarakel/Widgets/drawers/community_drawer/list_controller.dart';
import 'package:sarakel/Widgets/drawers/community_drawer/moderated_list.dart';
import 'package:sarakel/features/create_community/create_community.dart';
import 'package:sarakel/Widgets/profiles/communityprofile_page.dart';
import 'package:sarakel/models/community.dart';

class CommunityDrawer extends StatefulWidget {
  final String token;

  const CommunityDrawer({Key? key, required this.token}) : super(key: key);

  @override
  _CommunityDrawerState createState() => _CommunityDrawerState();
}

class _CommunityDrawerState extends State<CommunityDrawer> {
  bool isModeratingExpanded = true;
  bool isCommunitiesExpanded = true;
  List<Community>? fetchedCommunities;
  List<Community>? fetchedModeratedCommunities;

  @override
  void initState() {
    super.initState();
    initializeCommunities();
  }

  Future<void> initializeCommunities() async {
    // Load the moderated communities
    fetchedModeratedCommunities = await loadModeratedCircles();

    // Load other communities
    fetchedCommunities = await loadCircles();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: ListView(
          children: [
            if (fetchedModeratedCommunities != null &&
                fetchedModeratedCommunities!.isNotEmpty)
              Column(
                children: [
                  ListTile(
                    title: const Row(
                      children: [
                        Text('Moderating'),
                      ],
                    ),
                    trailing: Icon(isModeratingExpanded
                        ? Icons.arrow_drop_down
                        : Icons.arrow_right),
                    onTap: () {
                      setState(() {
                        isModeratingExpanded = !isModeratingExpanded;
                      });
                    },
                  ),
                  if (isModeratingExpanded &&
                      fetchedModeratedCommunities != null &&
                      fetchedModeratedCommunities!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: fetchedModeratedCommunities!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final community = fetchedModeratedCommunities![index];
                        return ListTile(
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(community.image),
                              ),
                              const SizedBox(width: 8),
                              Text('c/${community.name}'),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) {
                                return CommunityProfilePage(
                                  community: community,
                                  token: widget.token,
                                );
                              }),
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            const Divider(),
            Column(
              children: [
                ListTile(
                  title: const Row(
                    children: [
                      Text('Your Circles'),
                    ],
                  ),
                  trailing: Icon(isCommunitiesExpanded
                      ? Icons.arrow_drop_down
                      : Icons.arrow_right),
                  onTap: () {
                    setState(() {
                      isCommunitiesExpanded = !isCommunitiesExpanded;
                    });
                  },
                ),
                ListTile(
                  title: const Text('Create community'),
                  leading: const Icon(Icons.add),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CommunityForm(token: widget.token),
                      ),
                    );
                  },
                ),
                if (isCommunitiesExpanded &&
                    fetchedCommunities != null &&
                    fetchedCommunities!.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: fetchedCommunities!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final community = fetchedCommunities![index];
                      return ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(community.image),
                            ),
                            const SizedBox(width: 8), // Adjust spacing
                            Text('c/${community.name}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) {
                              return CommunityProfilePage(
                                community: community,
                                token: widget.token,
                              );
                            }),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
