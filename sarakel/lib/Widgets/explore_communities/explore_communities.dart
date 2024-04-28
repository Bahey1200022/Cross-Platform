import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/Widgets/drawers/community_drawer/community_list.dart';
import 'package:sarakel/Widgets/drawers/profile_drawer.dart';
import 'package:sarakel/Widgets/explore_communities/join_button.dart'; // Import the JoinButton widget
import 'package:sarakel/Widgets/explore_communities/join_button_controller.dart';
import 'package:sarakel/Widgets/explore_communities/leave_community_controller.dart';
import 'package:sarakel/Widgets/explore_communities/load_explore.dart';
import 'package:sarakel/Widgets/home/widgets/app_bar.dart';
import 'package:sarakel/Widgets/home/widgets/bottom_bar.dart';
import 'package:sarakel/Widgets/profiles/communityprofile_page.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/models/user.dart';

class ExploreCommunities extends StatefulWidget {
  final String token;

  const ExploreCommunities({Key? key, required this.token}) : super(key: key);

  @override
  State<ExploreCommunities> createState() => _ExploreCommunitiesState();
}

class _ExploreCommunitiesState extends State<ExploreCommunities> {
  final int _selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<Community>? fetchedCommunities;
  List<bool> _isJoinedList = []; // List to track join status of each community

  @override
  void initState() {
    super.initState();
    fetchCommunities();
  }

  void fetchCommunities() {
    explore().then((communities) {
      setState(() {
        fetchedCommunities = communities;
        _isJoinedList = List.generate(fetchedCommunities?.length ?? 0,
            (index) => false); // Initialize join status for each community
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(widget.token);

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Circles',
        scaffoldKey: _scaffoldKey, // Pass the GlobalKey to the CustomAppBar
      ),
      drawer: CommunityDrawer(token: widget.token),
      endDrawer: ProfileDrawer(
        user: User(username: jwtdecodedtoken['username'], token: widget.token),
      ),
      body: ListView.builder(
        itemCount: fetchedCommunities?.length ?? 0,
        itemBuilder: (context, index) {
          final item = fetchedCommunities?[index];
          return Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      item!.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: JoinButton(
                    isJoined: _isJoinedList[
                        index], // Use individual join status for each community
                    onPressed: () async {
                      if (_isJoinedList[index]) {
                        // If already joined, leave the community
                        await LeaveCommunityController.leaveCommunity(
                            item.name, widget.token);
                      } else {
                        // If not joined, join the community
                        await JoinCommunityController.joinCommunity(
                            item.name, widget.token);
                      }
                      setState(() {
                        _isJoinedList[index] = !_isJoinedList[
                            index]; // Toggle the join status for the current community
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) {
                        return CommunityProfilePage(
                          community: item,
                          token: widget.token,
                          showModToolsButton: false,
                          showJoinButton: true,
                        );
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        token: widget.token,
      ),
    );
  }
}
