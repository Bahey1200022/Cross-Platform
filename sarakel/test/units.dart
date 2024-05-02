import 'package:sarakel/Widgets/home/widgets/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

Future<bool> isLoggedInUser(String userName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loggedInUsername = prefs.getString('username');
  if (loggedInUsername == userName) {
    return true;
  } else {
    return false;
  }
}

void main() {
  group('User Profile', () {
    test('Logged in user is the same as the user profile', () async {
      SharedPreferences.setMockInitialValues({'username': 'testuser'});
      expect(await isLoggedInUser('testuser'), true);
    });

    test('Logged in user is not the same as the user profile', () async {
      SharedPreferences.setMockInitialValues({'username': 'testuser'});
      expect(await isLoggedInUser('anotheruser'), false);
    });
  });

  group('isVideo Function Test', () {
    test('Test with a video URL', () {
      var videoUrl = 'http://example.com/video.mp4';
      expect(isVideo(videoUrl), true);
    });

    test('Test with a non-video URL', () {
      var nonVideoUrl = 'http://example.com/image.jpg';
      expect(isVideo(nonVideoUrl), false);
    });

    test('Test with a URL that has no extension', () {
      var noExtensionUrl = 'http://example.com/';
      expect(isVideo(noExtensionUrl), false);
    });
  });
}
