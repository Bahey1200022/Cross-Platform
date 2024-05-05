import 'dart:typed_data';

import 'package:video_thumbnail/video_thumbnail.dart';

// ...

Future<Uint8List?> generateThumbnail(String videoPath) async {
  final uint8list = await VideoThumbnail.thumbnailData(
    video: videoPath,
    imageFormat: ImageFormat.JPEG,
    maxWidth:
        128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
    quality: 25,
  );

  return uint8list;
}
