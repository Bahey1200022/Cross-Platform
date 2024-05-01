import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/controllers/home_screen_controller.dart';
import 'package:sarakel/Widgets/home/homescreen.dart';
import 'package:sarakel/Widgets/home/widgets/post_card.dart';
import 'package:sarakel/models/post.dart';
import 'package:sarakel/user_profile/new_chat.dart';
import 'package:sarakel/user_profile/user_controller.dart';
import 'package:sarakel/user_profile/user_visibility.dart';
import 'package:sarakel/features/search_bar/search_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          const Text("Comments"),

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

    initializeVisibility();

    loadUserPosts(widget.user!.username!).then((posts) {
      if (mounted) {
        setState(() => postsToShow = posts);
      }
    });
  }

  void initializeVisibility() async {
    loggeduserIconIsVisible = await isLoggedInUser(widget.user!.username!);
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SarakelHomeScreen(
                                      homescreenController:
                                          HomescreenController(
                                              token: widget.user!.token!))));
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
                        icon: const Icon(Icons.share),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background gradient
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(5, 17, 114, 0.878),
                                  Color.fromARGB(255, 0, 0, 0),
                                ],
                              ),
                            ),
                          ),
                          // Additional widgets on the background
                          Positioned(
                            top: 50,
                            left: 20,
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(50), // Image radius
                                child: Image.asset(
                                  'assets/avatar_logo.jpeg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 170,
                            left: 20,
                            child: Visibility(
                              visible: loggeduserIconIsVisible,
                              child: OutlinedButton(
                                onPressed: () {},
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 170,
                            left: 20,
                            child: Visibility(
                              visible: !loggeduserIconIsVisible,
                              child: Row(
                                children: [
                                  OutlinedButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'follow',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () async {
                                      newChat(widget.user!.username!, context);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: const CircleBorder(),
                                    ),
                                    child: const Icon(
                                      Icons.message_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      shape: const CircleBorder(),
                                    ),
                                    child: const Icon(
                                      Icons.person_add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            top: 210,
                            left: 20,
                            child: Text(
                              widget.user!.username!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Raleway',
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 250,
                            left: 20,
                            child: InkWell(
                              onTap: () {
                                // Action code when the icon is clicked
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    '# followers  ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            top: 300,
                            left: 20,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.facebook,
                                                  color: Colors.blue,
                                                  size: 15,
                                                ),
                                                label: const Text(
                                                  'Facebook',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.reddit_rounded,
                                                  color: Colors.orange,
                                                  size: 15,
                                                ),
                                                label: const Text(
                                                  'Reddit',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.tiktok,
                                                  color: Colors.black,
                                                  size: 15,
                                                ),
                                                label: const Text(
                                                  'Tiktok',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () {},
                                                icon: const FaIcon(
                                                    FontAwesomeIcons.twitter,
                                                    color: Colors.blue,
                                                    size: 15),
                                                // icon: const Icon(
                                                //   Icons.facebook,
                                                //   color: Colors.blue,
                                                //   size: 15,
                                                // ),
                                                label: const Text(
                                                  'Twitter',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () {},
                                                icon: const FaIcon(
                                                    FontAwesomeIcons.soundcloud,
                                                    color: Colors.orange,
                                                    size: 15),
                                                label: const Text(
                                                  'SoundCloud',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () {},
                                                icon: const FaIcon(
                                                    FontAwesomeIcons.youtube,
                                                    color: Colors.red,
                                                    size: 15),
                                                label: const Text(
                                                  'Youtube',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () {},
                                                icon: const FaIcon(
                                                    FontAwesomeIcons.link,
                                                    // color: Colors.red,
                                                    size: 15),
                                                label: const Text(
                                                  'custom link',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    const Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                                // Your action when the button is clicked
                              },
                              label: const Text(
                                'Add social link',
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: const Icon(
                                Icons.add,
                                size: 30,
                                color: Colors.white,
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 37, 37, 37),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  title:
                      const Text('Books'), // This is the title in the app bar.
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
