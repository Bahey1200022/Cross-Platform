import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sarakel/features/create_community/create_community.dart';
import 'package:sarakel/Widgets/profiles/communityprofile_page.dart';
import 'package:sarakel/models/community.dart';
import 'list_controller.dart';

///////drawer of communities
// ignore: must_be_immutable
class CommunityDrawer extends ConsumerWidget {
  final String token;
  List<Community>? fetchedCommunities;
  CommunityDrawer({Key? key, required this.token}) {
    initializeCommunities();
  }

  void initializeCommunities() {
    loadCircles().then((communities) {
      fetchedCommunities = communities;
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Create community'),
              leading: Icon(Icons.add),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommunityForm(token: token)));
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: fetchedCommunities?.length,
                itemBuilder: (BuildContext context, int index) {
                  final community = fetchedCommunities?[index];
                  return ListTile(
                    title: Text('c/${community?.name}'),
                    leading: community?.is18Plus == true
                        ? const Icon(Icons.warning)
                        : null,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) {
                          return CommunityProfilePage(
                            community: community!,
                            token: token,
                            showJoinButton: false,
                          );
                        }),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
