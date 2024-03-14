import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:sarakel/controllers/home_screen_controller.dart';

import '../../models/community.dart';
import '../../providers/user_communities.dart';

class ExploreCommunities extends StatefulWidget {
  const ExploreCommunities({Key? key});
  @override
  State<ExploreCommunities> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ExploreCommunities> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Community> fetchedCommunities =
        Provider.of<UserCommunitiesProvider>(context, listen: false)
            .communities;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("communities"),
      ),
      body: ListView.builder(
        itemCount: fetchedCommunities.length,
        itemBuilder: (context, index) {
          final item = fetchedCommunities[index];
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
                      item.image, // Assuming 'image' is the key for the image URL in your JSON
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
                ),
              ),
              SizedBox(height: 5), // Add spacing between each card
            ],
          );
        },
      ),
    );
  }
}
