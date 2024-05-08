// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:sarakel/constants.dart';
import 'package:sarakel/models/community.dart';
import 'package:http/http.dart' as http;

///function that gets the community
Future<Community> getCommunity(String CommunityName) async {
  var response = await http.get(Uri.parse(
      '$BASE_URL/api/community/$CommunityName/getCommunityInfoByName'));

  if (response.statusCode == 200) {
    var jsondata = jsonDecode(response.body);
    var data = jsondata['data']['data'];
    //print(data);
    return Community(
      id: data['_id'],
      name: data['communityName'] ?? "",
      description: data['description'] ?? "",
      backimage: data['backgroundPicUrl'] ??
          "https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0",
      image: data['displayPicUrl'] ??
          "https://th.bing.com/th/id/R.cfa6aef7e239c59240261cfcc2ab9063?rik=MCdYhA5MWh4W4g&riu=http%3a%2f%2fclipart-library.com%2fnew_gallery%2f118-1182264_orange-circle-with-black-outline.png&ehk=y2cy3yUQQXMU1oZejNa1TdkIke9qTXPkWWc0mQSLtGA%3d&risl=&pid=ImgRaw&r=0",
      is18Plus: data['isNSFW'],
      type: data['type'] ?? "public",
    );
  } else {
    return Community(
      id: '',
      name: '',
      description: '',
      image: '',
      is18Plus: false,
      type: '',
    );
  }
}
