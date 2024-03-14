import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/providers/user_communities.dart';
import 'package:provider/provider.dart' as provider;

class communityDrawer extends ConsumerWidget {
  String userID;
  communityDrawer({super.key, required this.userID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Community> fetchedCommunities =
        provider.Provider.of<UserCommunitiesProvider>(context, listen: false)
            .communities;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text('Create a circle'),
              leading: Icon(Icons.add),
              onTap: () {
                print(fetchedCommunities);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: fetchedCommunities.length,
                itemBuilder: (BuildContext context, int index) {
                  final community = fetchedCommunities?[index];
                  return ListTile(
                    title: Text('${community?.name}'),
                    onTap: () {},
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
