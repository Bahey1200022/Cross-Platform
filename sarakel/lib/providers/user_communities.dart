import 'package:flutter/material.dart';
import 'package:sarakel/models/community.dart';

class UserCommunitiesProvider extends ChangeNotifier {
  List<Community> _communities = [];

  List<Community> get communities => _communities;

  //
  setCommunity(List<Community> community) {
    _communities = community;
    notifyListeners();
  }

  removeUser(Community community) {
    _communities.remove(community);
    notifyListeners();
  }
}
