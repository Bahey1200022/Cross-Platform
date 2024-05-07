import 'dart:typed_data';

import 'package:video_thumbnail/video_thumbnail.dart';

/// Generate a thumbnail from a video file
Future<Uint8List?> generateThumbnail(String videoPath) async {
  final uint8list = await VideoThumbnail.thumbnailData(
    video: videoPath,
    imageFormat: ImageFormat.JPEG,
    maxWidth: 128,
    quality: 25,
  );

  return uint8list;
}
