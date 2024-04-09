import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sarakel/Widgets/drawers/community_drawer/list_controller.dart';
import 'package:sarakel/models/community.dart';

import '../drawers/community_drawer/community_list.dart';
import '../drawers/profile_drawer.dart';
import '../../models/user.dart';
import '../profiles/communityprofile_page.dart';
import '../home/widgets/app_bar.dart';
import '../home/widgets/bottom_bar.dart';

// ignore: must_be_immutable
class ExploreCommunities extends StatefulWidget {
  final String token;

  ExploreCommunities({super.key, required this.token});

  @override
  State<ExploreCommunities> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ExploreCommunities> {
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
    Map<String, dynamic> jwtdecodedtoken = JwtDecoder.decode(widget.token);
    print(fetchedCommunities?.length);
    return Scaffold(
      key: _scaffoldKey, // Assign key here

      appBar: CustomAppBar(
        title: 'Circles',
        scaffoldKey: _scaffoldKey, // Pass the GlobalKey to the CustomAppBar
      ),
      drawer: CommunityDrawer(token: widget.token),
      endDrawer: ProfileDrawer(
        user: User(username: jwtdecodedtoken['username'], token: widget.token),
      ),
      body: ListView.builder(
        itemCount: fetchedCommunities?.length,
        itemBuilder: (context, index) {
          final item = fetchedCommunities?[index];
          return Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                ),
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      item!
                          .image, // Assuming 'image' is the key for the image URL in your JSON
                      width: 50, // Adjust as needed
                      height: 50, // Adjust as needed
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Action when the "Join" button is pressed
                      // You can implement your logic here
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors
                          .blue), // Set the button background color to blue
                    ),
                    child: Text(
                      'Join',
                      style: TextStyle(
                          color: Colors.white), // Set the text color to white
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) {
                        return CommunityProfilePage(
                            community: item, token: widget.token);
                      }),
                    );
                  },
                ),
              ),
              SizedBox(height: 5), // Add spacing between each card
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
