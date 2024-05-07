// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/Widgets/chatting/conversations.dart';
import 'package:sarakel/Widgets/chatting/one_on_one.dart';
import 'package:sarakel/Widgets/chatting/send_message.dart';
import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void newChat(String name, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var username = prefs.getString('username');
  var response = await http.post(
    Uri.parse('$BASE_URL/api/message/converstaionId'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'recipient': name}),
  );

  if (response.statusCode == 200) {
    var jsondata = jsonDecode(response.body);
    if (jsondata == 'no conversation') {
      await sendMessage('Hi, I am using Sarakel', name);
      List convos = await loadConversation();
      for (var convo in convos) {
        if (convo['users'] == name) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChatPage(
                receiver: name,
                sender: username!,
                token: token!,
                id: convo['id']);
          }));
        }
      }
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ChatPage(
            receiver: name, sender: username!, token: token!, id: jsondata);
      }));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Failed to go to chat'),
    ));
  }
}
