// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sarakel/constants.dart';

///controller for creating a post
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
    DateTime? date,
    TimeOfDay? time,
  ) async {
    try {
      ///API endpoint for creating a post
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
          'scheduled': jsonEncode({
            'date': date?.toIso8601String(),
            'time': time != null ? '${time.hour}:${time.minute}' : null,
          }),
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
          print('Post added successfully with $date and $time');
          print('Response body: ${await response.stream.bytesToString()}');
        } else {
          print('Failed to add post. Status code: ${response.statusCode}');
          print('Response body: ${await response.stream.bytesToString()}');
        }
      }
    } catch (e) {
      print('Error adding post: $e');
    }
  }
}
