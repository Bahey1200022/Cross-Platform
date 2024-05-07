// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:sarakel/models/post.dart';

import 'loading.dart';

void main() {
  group('loadPosts', () {
    test('should return a list of Post objects', () {
      // Call the function
      List<Post> posts = loadposts();

      // Check that the function returned a list
      expect(posts, isA<List<Post>>());

      // Check that the list is not empty
      expect(posts, isNotEmpty);

      // Check the properties of the first Post object
      expect(posts[1].communityName, equals('community1'));
      expect(posts[1].id, equals('post1'));
      // Add more checks for the other properties...

      // Check the properties of the second Post object
      expect(posts[0].communityName, equals('community2'));
      expect(posts[0].id, equals('post2'));
      // Add more checks for the other properties...
    });
  });
}
