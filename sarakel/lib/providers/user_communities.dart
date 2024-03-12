import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/models/community.dart';

class UserCommunitiesProvider extends ChangeNotifier {
  List<Community>? _communities = [];

  List<Community>? get communities => _communities;

  //
  setCommunity(List<Community> community) {
    _communities = community;
    notifyListeners();
  }

  removeUser(Community community) {
    _communities?.remove(community);
    notifyListeners();
  }
}
