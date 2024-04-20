// ignore_for_file: unused_local_variable, empty_catches

import 'dart:convert';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:sarakel/constants.dart';
import 'package:sarakel/models/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

///setttings  controller class to handle user settings
class Settings {
  final String token;
  UserPreferences? prefs;

  Settings({required this.token}) {
    loadpreferences().then((value) => prefs = value);
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.pushNamed(context, '/welcome');
  }

  void deleteAccount(BuildContext context, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.pushNamed(context, '/welcome');
  }

  Future<String?> country(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => CountryListPick(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Select Country'),
        ),
        theme: CountryTheme(
          isShowFlag: true,
          isShowTitle: true,
          isDownIcon: true,
          showEnglishName: true,
        ),
        initialSelection: '+20',
      ),
    );

    if (result != null) {
      return result['name'];
    } else {
      return null;
    }
  }

  void gender(BuildContext context, String token) async {
    String selectedGender = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select your Gender'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Male'),
              onTap: () {
                Navigator.pop(context, 'Male');
              },
            ),
            ListTile(
              title: const Text('Female'),
              onTap: () {
                Navigator.pop(context, 'Female');
              },
            ),
          ],
        ),
      ),
    );
  }

  bool googleConnected(String token) {
    return true;
  }

  Future<UserPreferences> loadpreferences() async {
    try {
      // Make a GET request to fetch the JSON data from the server
      var response = await http.get(
        Uri.parse('$BASE_URL/api/v1/me/prefs'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Decode the JSON response into a list
        var jsonData = json.decode(response.body);
        var settings = jsonData['settings'];

        // Map the community data to Community objects
        return UserPreferences(
          showNSFW: settings['showMatureContent'],
          showInSearch: settings['showInSearch'],
          personalizeAds: settings['personalizeAds'],
          dating: settings['dating'],
          alcahol: settings['alcohol'],
          gambling: settings['gambling'],
          pregnancyAndParenting: settings['pregnancyAndParenting'],
          weightLoss: settings['weightLoss'],
          privateMessagesEmail: settings['privateMessagesEmail'],
          chatMessages: settings['chatMessages'],
        );
      } else {
        // Return an empty list if the response status code is not 200
        return UserPreferences(
          showNSFW: false,
          showInSearch: false,
          personalizeAds: false,
          dating: false,
          alcahol: false,
          gambling: false,
          pregnancyAndParenting: false,
          weightLoss: false,
          privateMessagesEmail: false,
          chatMessages: false,
        );
      }
    } catch (e) {
      // Return an empty list if an error occurs
      return UserPreferences(
        showNSFW: false,
        showInSearch: false,
        personalizeAds: false,
        dating: false,
        alcahol: false,
        gambling: false,
        pregnancyAndParenting: false,
        weightLoss: false,
        privateMessagesEmail: false,
        chatMessages: false,
      );
    }
  }

  // Make a patch request to update the user's preferences
  void change(String prefe, bool v) async {
    try {
      // Create a map of the preferences you want to update
      var updatedPrefs = {
        prefe: v,
        // Add other preferences here
      };
      var data = json.encode(updatedPrefs);
      // Make a PATCH request to update the user's preferences
      var response = await http.patch(
        Uri.parse('$BASE_URL/api/v1/me/prefs/?'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: data,
      );
      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Preferences updated successfully
      } else {
        // Failed to update preferences
      }
    } catch (e) {}
  }
}
