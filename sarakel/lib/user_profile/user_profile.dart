import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/widgets/comment_card.dart';
import 'package:sarakel/Widgets/home/widgets/post_card.dart';
import 'package:sarakel/models/comment.dart';
import 'package:sarakel/models/post.dart';
import 'package:sarakel/user_profile/invitations.dart';
import 'package:sarakel/user_profile/user_controller.dart';
import 'package:sarakel/user_profile/user_space_bar.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserProfile extends StatefulWidget {
  final User? user;

  const UserProfile({super.key, required this.user});

  @override
  State<UserProfile> createState() {
    return _UserProfile();
  }
}

class _UserProfile extends State<UserProfile> {
  bool loggeduserIconIsVisible = false;

  List<Post> postsToShow = [];
  List<Comment> commentsToShow = [];

  List<Widget> getTabWidgets(String tabName) {
    switch (tabName) {
      case "Posts":
        return [
          ListView.builder(
              itemCount: postsToShow.length,
              itemBuilder: (context, index) {
                final post = postsToShow[index];

                // Show the post
                return PostCard(
                  post: post,
                  onHide: () {},
                );
              }),

          // Add more widgets as needed
        ];
      case "Comments":
        return [
          ListView.builder(
              itemCount: commentsToShow.length,
              itemBuilder: (context, index) {
                final comment = commentsToShow[index];

                // Show the post
                return CommentCard(
                  comment: comment,
                  onReply: (String param1, String param2) {},
                );
              }),
          // Add more widgets as needed
        ];

      default:
        return [
          const Text("Default Widget"),
          // Add more widgets as needed
        ];
    }
  }

  @override
  void initState() {
    super.initState();

    loadUserPosts(widget.user!.username!).then((posts) {
      if (mounted) {
        setState(() => postsToShow = posts);
      }
    });
    loadUserComments(widget.user!.username!).then((comments) {
      if (mounted) {
        setState(() => commentsToShow = comments);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    final List<String> tabs = <String>['Posts', 'Comments'];
    return DefaultTabController(
      length: tabs.length, // This is the number of tabs.
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: Colors.blue,
                  toolbarHeight: 50,
                  leadingWidth: widthScreen,

                  leading: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: widthScreen - 180,
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        color: Colors.white,
                        onPressed: () {
                          showSearch(
                              context: context, delegate: sarakelSearch());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.mail_rounded),
                        color: Colors.white,
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? logged = prefs.getString('username');
                          if (widget.user!.username == logged) {
                            // getInvitations(widget.user!.username!, context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Invitations(
                                  username: widget.user!.username!,
                                ),
                              ),
                            );
                          } else {
                            // var options = await getBlockedUsers();
                            // if (options.contains(widget.user!.username!)) {
                            //   // Do something

                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         title: const Text('Confirmation'),
                            //         content: const Text(
                            //             'Are you sure you want to unblock the user?'),
                            //         actions: [
                            //           TextButton(
                            //             child: const Text('Cancel'),
                            //             onPressed: () {
                            //               Navigator.of(context).pop();
                            //             },
                            //           ),
                            //           TextButton(
                            //             child: const Text('Unblock'),
                            //             onPressed: () {
                            //               unblockUser(widget.user!.username!);
                            //               Navigator.of(context).pop();
                            //             },
                            //           ),
                            //         ],
                            //       );
                            //     },
                            //   );
                            // } else {}

                            //   // Handle the selected option
                            //     if (state == 'Block User') {
                            //       blockUser(widget.user!.username!);
                            //       // Do something for option 1
                            //     } else {
                            //       unblockUser(widget.user!.username!);
                            //     }
                            // //////////////
                          }
                        },
                      ),
                    ],
                  ),
                  flexibleSpace: UserSpaceBar(
                    user: widget.user,
                  ),

                  title: const Text(
                      'user profile'), // This is the title in the app bar.
                  pinned: true,
                  expandedHeight: 400,

                  forceElevated: innerBoxIsScrolled,

                  bottom: TabBar(
                    dividerColor: Colors.white,
                    dividerHeight: 50,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black,

                    // These are the widgets to put in each tab in the tab bar.
                    tabs: tabs.map((String name) => Tab(text: name)).toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: tabs.map((String tabName) {
              List<Widget> tabsWidgets = getTabWidgets(tabName);
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>(tabName),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: SliverFixedExtentList(
                            itemExtent: 600.0,
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return tabsWidgets[index];
                              },
                              childCount: tabsWidgets.length,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
