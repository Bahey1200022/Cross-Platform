bool isVideo(String url) {
  var uri = Uri.parse(url);
  var path = uri.path;
  var extension = path.substring(path.lastIndexOf('.') + 1);
  var videoExtensions = ['mp4', 'avi', 'mov', 'mkv', 'flv', 'wmv'];
  return videoExtensions.contains(extension);
}
