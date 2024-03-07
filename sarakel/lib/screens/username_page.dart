import 'package:flutter/material.dart';

class UsernamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('Create Username'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo_2d.png', height: 100.0),
              SizedBox(height: 50.0),
              Text(
                'Create your username',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                'Most Sarakelers use an anonymous username.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'You won\'t be able to change it later.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Handle continue
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
