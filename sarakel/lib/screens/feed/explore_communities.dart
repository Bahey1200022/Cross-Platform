import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';

var posts = [];

class ExploreCommunities extends StatefulWidget {
  const ExploreCommunities({Key? key});

  @override
  State<ExploreCommunities> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ExploreCommunities> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
    _timer = Timer.periodic(Duration(seconds: 20),
        (Timer t) => fetchData()); // Fetch data every 30 seconds
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void fetchData() async {
    final dio = Dio();
    final response = await dio.get('http://localhost:3000/communities');
    print(response.data);
    setState(() {
      posts = response.data; // Update the state with fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("communities"),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final item = posts[index];
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
                      item[
                          'image'], // Assuming 'image' is the key for the image URL in your JSON
                      width: 50, // Adjust as needed
                      height: 50, // Adjust as needed
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(item['name']),
                  subtitle: Text(item['description']),
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
