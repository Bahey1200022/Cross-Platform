import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

class AddPostController {
  Future<void> addPost(
    String communityName,
    String communityId,
    String title,
    String body,
    String token,
    String url,
    bool isSpoiler,
    bool isNSFW,
    bool isBA,
    File? image,
    File? video,
  ) async {
    try {
      // if (title.trim().isNotEmpty) {
      //   const String apiUrl = '$BASE_URL/api/createPost/create';

      //   final Map<String, String> headers = {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $token',
      //   };

      //   // ignore: avoid_print
      //   print('Token: $token');
      //   final Map<String, dynamic> postData = {
      //     'content': body,
      //     'title': title,
      //     //mediaUrl: url,
      //     //downvotes: 0,
      //     'communityId': communityName,
      //     //upvotes: 0,
      //     //scheduledAt: null,
      //     'isSpoiler': isSpoiler,
      //     //isLocked: false,
      //     //isReported: false,
      //     //isReason: null,
      //     'nsfw': isNSFW,
      //     'ac': isBA,
      //     'url': url,
      //     //flair: null,
      //   };

      //   final String postJson = jsonEncode(postData);
      //   // ignore: avoid_print
      //   print('Post Data: $postJson');

      //   final http.Response response = await http.post(
      //     Uri.parse(apiUrl),
      //     headers: headers,
      //     body: postJson,
      //   );

      //   if (response.statusCode == 201 || response.statusCode == 200) {
      //     //print('userId: $username');
      //     // ignore: avoid_print
      //     print('Post added successfully');
      //   } else {
      //     // ignore: avoid_print
      //     print('Failed to add post. Status code: ${response.statusCode}');
      //     // ignore: avoid_print
      //     print('Response body: ${response.body}');
      //   }
      // }

      if (title.trim().isNotEmpty) {
        const String apiUrl = '$BASE_URL/api/createPost/create';

        final Map<String, String> headers = {
          'Authorization': 'Bearer $token',
        };

        final Map<String, String> fields = {
          'content': body,
          'title': title,
          'communityId': communityName,
          'isSpoiler': isSpoiler.toString(),
          'nsfw': isNSFW.toString(),
          'ac': isBA.toString(),
        };

        final http.MultipartRequest request =
            http.MultipartRequest('POST', Uri.parse(apiUrl));

        if (image != null) {
          final http.MultipartFile imageFile =
              await http.MultipartFile.fromPath(
            'media',
            image.path,
          );
          request.files.add(imageFile);
        }
        request.headers.addAll(headers);
        request.fields.addAll(fields);

        if (image != null) {
          final http.MultipartFile imageFile =
              await http.MultipartFile.fromPath(
            'image',
            image.path,
          );
          request.files.add(imageFile);
        }

        final http.StreamedResponse response = await request.send();

        if (response.statusCode == 201 || response.statusCode == 200) {
          print('Post added successfully');
          print('Response body: ${await response.stream.bytesToString()}');
        } else {
          print('Failed to add post. Status code: ${response.statusCode}');
          print('Response body: ${await response.stream.bytesToString()}');
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error adding post: $e');
    }
  }
}
