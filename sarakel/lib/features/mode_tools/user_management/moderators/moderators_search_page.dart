import 'package:flutter/material.dart';

class ModeratorSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false, // Removes the back arrow
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true, // Focus the text field on page load
                    decoration: InputDecoration(
                      hintText: 'Search by username',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black, // Color of the search icon
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color.fromARGB(255, 124, 119, 119),
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Smaller font size
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Search by username',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20, // Increased font size
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Only exact matches will be found',
              style: TextStyle(fontSize: 18), // Increased font size
            ),
          ],
        ),
      ),
    );
  }
}
