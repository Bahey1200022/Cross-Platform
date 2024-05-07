// ignore_for_file: file_names

import 'package:flutter_test/flutter_test.dart';
import 'package:sarakel/models/community.dart';

import 'loading.dart';

void main() {
  test('loadCircles should return a list of Community objects', () {
    // Call the function
    List<Community> communities = loadcircles();

    // Check that the function returned a list
    expect(communities, isA<List<Community>>());

    // Check that the list is not empty
    expect(communities, isNotEmpty);

    // Check the properties of the first Community object
    expect(communities[0].id, equals('community1'));
    expect(communities[0].name, equals('Community 1'));
    // Add more checks for the other properties...

    // Check the properties of the second Community object
    expect(communities[1].id, equals('community2'));
    expect(communities[1].name, equals('Community 2'));
    // Add more checks for the other properties...
  });
}
