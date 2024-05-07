// community_profile_page.dart

// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/explore_communities/join_button.dart';
import 'package:sarakel/Widgets/profiles/accept-invite.dart';
import 'package:sarakel/Widgets/profiles/community_info.dart';
import 'package:sarakel/features/mode_tools/moderator_tools.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/Widgets/explore_communities/join_button_controller.dart';
import 'package:sarakel/Widgets/explore_communities/leave_community_controller.dart';
import 'package:sarakel/models/post.dart';
import 'package:sarakel/Widgets/home/widgets/post_card.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:sarakel/Widgets/profiles/communityposts.dart';
import 'user_service.dart';

///CommunityProfilePage
///ui class for community profile page
class CommunityProfilePage extends StatefulWidget {
  final Community community;
  final String token;

  const CommunityProfilePage({
    super.key,
    required this.community,
    required this.token,
  });

  @override
  _CommunityProfilePageState createState() => _CommunityProfilePageState();
}

class _CommunityProfilePageState extends State<CommunityProfilePage> {
  late Future<List<Post>> _communityPostsFuture;
  UserRole _userRole = UserRole.notLoggedIn;

  @override
  void initState() {
    super.initState();
    _communityPostsFuture = fetchCommunityPosts(widget.community.name);
    fetchUserRoles(widget.token, widget.community.name).then((userRole) {
      setState(() {
        _userRole = userRole;
      });
    }).catchError((error) {
      print('Failed to fetch user roles: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 43, 126, 243),
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
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text(
                                  'Accept invite to be a moderator?'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Handle "Yes" button press
                                      acceptInvite(widget.community.name,
                                          widget.token, context);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'You are now a moderator in ${widget.community.name}!'),
                                        ),
                                      );
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle "No" button press
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(widget.community.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'c/${widget.community.name}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (_userRole == UserRole.moderator) ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModeratorTools(
                            token: widget.token,
                            community: widget.community,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Mod Tools',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                if (_userRole == UserRole.member ||
                    _userRole == UserRole.notMember) ...[
                  const SizedBox(height: 16),
                  JoinButton(
                    isJoined: _userRole == UserRole.member,
                    onPressed: () async {
                      setState(() {
                        _userRole = _userRole == UserRole.member
                            ? UserRole.notMember
                            : UserRole.member;
                      });
                      if (_userRole == UserRole.member) {
                        await JoinCommunityController.joinCommunity(
                            widget.community.name, widget.token);
                      } else {
                        await LeaveCommunityController.leaveCommunity(
                            widget.community.name, widget.token);
                      }
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InfoCommunity(
                        community: widget.community, token: widget.token),
                  ),
                );
              },
              child: const Text(
                'See more',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  CustomMaterialIndicator(
                    onRefresh: () async {
                      setState(() {
                        _communityPostsFuture =
                            fetchCommunityPosts(widget.community.name);
                      });
                    },
                    indicatorBuilder: (context, controller) {
                      return Image.asset('assets/logo_2d.png', width: 30);
                    },
                    child: FutureBuilder<List<Post>>(
                      future: _communityPostsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  PostCard(
                                    post: snapshot.data![index],
                                    onHide: () {},
                                  ),
                                  // const Divider(),
                                ],
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text('No community posts'));
                        }
                      },
                    ),
                  ),
                  const Center(
                    child: Text('Saved Comments View'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
