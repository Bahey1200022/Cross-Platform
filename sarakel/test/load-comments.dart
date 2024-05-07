// ignore_for_file: file_names

import 'package:sarakel/models/comment.dart';
import 'package:test/test.dart';

import 'loading.dart';

void main() {
  test('loadcomments should return a list of Comment objects', () {
    // Call the function
    List<Comment> comments = loadcomments();

    // Check that the function returned a list
    expect(comments, isA<List<Comment>>());

    // Check that the list is not empty
    expect(comments, isNotEmpty);

    // Check the properties of the first Comment object
    expect(comments[0].id, equals('comment1'));
    expect(comments[0].content, equals('This is comment 1'));
    // Add more checks for the other properties...

    // Check the properties of the second Comment object
    expect(comments[1].id, equals('comment2'));
    expect(comments[1].content, equals('This is comment 2'));
    // Add more checks for the other properties...
  });
}
