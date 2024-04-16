import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/explore_communities/join_button.dart'; // Import the JoinButton widget
import 'package:sarakel/Widgets/explore_communities/join_button_controller.dart';
import 'package:sarakel/Widgets/explore_communities/leave_community_controller.dart';
import 'package:sarakel/Widgets/profiles/communityprofile_page.dart';
import 'package:sarakel/models/community.dart';

class ExploreCommunities extends StatefulWidget {
  final String token;

  ExploreCommunities({Key? key, required this.token}) : super(key: key);

  @override
  State<ExploreCommunities> createState() => _ExploreCommunitiesState();
}

class _ExploreCommunitiesState extends State<ExploreCommunities> {
  int _selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<Community>? fetchedCommunities;
  bool _isJoined = false; // Track if the user has joined the community

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Circles'),
      ),
      drawer: Drawer(), // Add your drawer widget here
      endDrawer: Drawer(), // Add your profile drawer widget here
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
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    isJoined: _isJoined,
                    onPressed: () async {
                      if (_isJoined) {
                        // If already joined, leave the community
                        await LeaveCommunityController.leaveCommunity(
                            item.name, widget.token);
                      } else {
                        // If not joined, join the community
                        await JoinCommunityController.joinCommunity(
                            item.name, widget.token);
                      }
                      setState(() {
                        _isJoined = !_isJoined; // Toggle the join status
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) {
                        return CommunityProfilePage(
                          community: item,
                          token: widget.token,
                        );
                      }),
                    );
                  },
                ),
              ),
              SizedBox(height: 5),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
