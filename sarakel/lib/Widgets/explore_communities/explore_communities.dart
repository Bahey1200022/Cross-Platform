import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/drawers/community_drawer/list_controller.dart';
import 'package:sarakel/Widgets/explore_communities/join_button_controller.dart';
import 'package:sarakel/Widgets/profiles/communityprofile_page.dart';
import 'package:sarakel/models/community.dart';
import 'package:sarakel/widgets/explore_communities/join_button.dart'; // Import the JoinButton widget

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

  @override
  void initState() {
    super.initState();
    fetchCommunities();
  }

  void fetchCommunities() {
    loadCircles().then((communities) {
      setState(() {
        fetchedCommunities = communities;
      });
    });
  }

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
                    onPressed: () async {
                      // Call the joinCommunity function from the controller
                      await JoinCommunityController.joinCommunity(
                          item.name, widget.token);
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
