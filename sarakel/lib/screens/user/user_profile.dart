import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  @override
  State<UserProfile> createState() {
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          initialIndex: 1,
          length: 3,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size(500, 380),
              child: AppBar(
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(5, 17, 114, 0.878),
                              Color.fromARGB(255, 0, 0, 0),
                            ]),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              // Container(
                              //   child:
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                  const SizedBox(
                                    width: 230,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.search),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.share),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ],
                              ),

                              ClipOval(
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(50), // Image radius
                                  child: Image.asset(
                                    'assets/avatar_logo.jpeg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const Text(
                                'User_Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Raleway',
                                  fontSize: 25,
                                ),
                              ),

                              InkWell(
                                onTap: () {
                                  // Action code when the icon is clicked
                                  print("The icon is clicked");
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
                              const Text('u/User_Name . 1 karma ..........',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13)),

                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Your action when the button is clicked
                                  print("Button clicked!");
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
                                    Color.fromARGB(255, 37, 37, 37),
                                  ),
                                ),
                                // Set the background color to transparent
                                // Other customizations (e.g., text color, padding, etc.) can go here
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                bottom: const TabBar(
                  labelColor: Color.fromARGB(255, 5, 1, 14),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3.0), // Customize the width
                    insets: EdgeInsets.symmetric(
                        horizontal: 0.0), // Customize the horizontal padding
                  ),
                  tabs: [
                    Tab(text: 'Posts'),
                    Tab(text: 'Comments'),
                    Tab(text: ' About'),
                  ],
                ),
              ),
            ),
            body: const TabBarView(children: [
              // Content for Posts tab
              Center(child: Text('Posts content goes here')),
              // Content for Comments tab
              Center(child: Text('Comments content goes here')),
              // Content for About tab
              Center(child: Text('About content goes here')),
            ]),
          )),
    );
  }
}
