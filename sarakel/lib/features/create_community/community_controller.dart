import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';

///create community with backend
/// feat still in construction from backend
class CreateCommunityController {
  static Future<void> createCommunity(
      String communityName, String communityType, bool is18Plus) async {
    print('Creating community...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      print('No token found');
      return;
    }
    print('Token retrieved: $token');
    //bool circleExists = await checkCircleExists(communityName);
    //bool idExists = await checkCircleIdExists(
    //communityName.toLowerCase().replaceAll(' ', '_'));

    //if (circleExists || idExists) {
    //print(
    //'Circle with the name "$communityName" already exists. Please choose a different name.');
    //return;
    //}

    String formattedCommunityName = communityName;
    String communityId = communityName.toLowerCase().replaceAll(' ', '_');

    var uri = Uri.parse('$BASE_URL/api/site_admin');
    var request = http.MultipartRequest('POST', uri)
      ..fields['communityName'] = formattedCommunityName
      ..fields['type'] = communityType
      ..fields['isNSFW'] = is18Plus.toString();

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();

      // Add the file to the multipart request
      var multipartFile = http.MultipartFile('displayPic', stream, length,
          filename: basename(file.path));
      request.files.add(multipartFile);
    } else {
      // User canceled the file picking
      print('File picking canceled');
      return;
    }

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    });

    var response = await request.send();

    print('Response status code: ${response.statusCode}');
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('hi');
      var responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');
      print('Community created successfully with ID: $communityId');
    } else {
      print('Failed to create community. Error: ');
    }
  }
}
