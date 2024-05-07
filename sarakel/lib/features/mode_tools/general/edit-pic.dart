import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sarakel/constants.dart';

void editCommunityPic(String community, String token) async {
  try {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$BASE_URL/api/community/updateDisplayPic'));

    // Add community and token as fields
    request.fields['communityName'] = community;

    // Add image file
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
    // Send request
    var response = await request.send();
    // Get response body
    var responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');
    // Get response
    if (response.statusCode == 200) {
      print('Request successful');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print(e);
  }
}
