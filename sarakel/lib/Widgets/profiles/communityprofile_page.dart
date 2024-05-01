// community_profile_page.dart

import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/explore_communities/join_button.dart';
import 'package:sarakel/features/mode_tools/moderator_tools.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/Widgets/explore_communities/join_button_controller.dart';
import 'package:sarakel/Widgets/explore_communities/leave_community_controller.dart';
import 'package:sarakel/models/post.dart';
import 'package:sarakel/Widgets/home/widgets/post_card.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:sarakel/Widgets/profiles/communityposts.dart';
import 'user_service.dart';

class CommunityProfilePage extends StatefulWidget {
  final Community community;
  final String token;

  const CommunityProfilePage({
    Key? key,
    required this.community,
    required this.token,
  }) : super(key: key);

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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo_2d.png'),
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/avatar_logo.jpeg'),
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
                        fontSize: 20,
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
                if (_userRole == UserRole.member || _userRole == UserRole.notMember) ...[
                  const SizedBox(height: 16),
                  JoinButton(
                    isJoined: _userRole == UserRole.member,
                    onPressed: () async {
                      setState(() {
                        _userRole = _userRole == UserRole.member ? UserRole.notMember : UserRole.member;
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
              onPressed: () {},
              child: const Text(
                'See Community Info',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FutureBuilder<List<Post>>(
                    future: _communityPostsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
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
                        return const Center(child: Text('No community posts'));
                      }
                    },
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
