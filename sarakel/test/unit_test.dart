import 'package:sarakel/Widgets/home/widgets/functions.dart';
import 'package:test/test.dart';

bool _validateEmail(String email) {
  // Regular expression for email validation
  RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email) || email.isNotEmpty;
}

String extractUrl(String s) {
  RegExp exp =
      RegExp(r'\[(.*?)\]'); // Regex pattern to match text within brackets
  Match? match = exp.firstMatch(s);
  return match != null
      ? match.group(1)!
      : s; // Return the URL without brackets, or the original string if no match is found
}

bool _validatePassword(String password) {
  // Password validation criteria: At least 8 characters
  return password.length >= 3;
}

String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  final Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays}d';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m';
  } else {
    return '${difference.inSeconds}s';
  }
}

void main() {
  group('Email Validation', () {
    test('Empty email returns false', () {
      expect(_validateEmail(''), false);
    });

    test('Valid email returns true', () {
      expect(_validateEmail('test@example.com'), true);
    });
  });

  group('Password Validation', () {
    test('Password with less than 3 characters returns false', () {
      expect(_validatePassword('12'), false);
    });

    test('Password with 3 characters returns true', () {
      expect(_validatePassword('123'), true);
    });

    test('Password with more than 3 characters returns true', () {
      expect(_validatePassword('1234'), true);
    });
  });

  group('URL Extraction', () {
    test('Extracts URL from string with brackets', () {
      expect(extractUrl('[https://example.com]'), 'https://example.com');
    });

    test('Returns original string when no brackets', () {
      expect(extractUrl('https://example.com'), 'https://example.com');
    });
  });
  group('Video URL Check', () {
    test('Returns true for .mp4 URL', () {
      expect(isVideo('https://example.com/video.mp4'), true);
    });

    test('Returns true for .avi URL', () {
      expect(isVideo('https://example.com/video.avi'), true);
    });

    test('Returns false for .jpg URL', () {
      expect(isVideo('https://example.com/image.jpg'), false);
    });

    test('Returns false for URL without extension', () {
      expect(isVideo('https://example.com/video'), false);
    });
  });
  test('formatDateTime should return a formatted string', () {
    // Call the function with a date-time string 2 days ago
    String result = formatDateTime(
        DateTime.now().subtract(Duration(days: 2)).toIso8601String());
    // Check that the function returned '2d'
    expect(result, equals('2d'));

    // Call the function with a date-time string 3 hours ago
    result = formatDateTime(
        DateTime.now().subtract(Duration(hours: 3)).toIso8601String());
    // Check that the function returned '3h'
    expect(result, equals('3h'));

    // Call the function with a date-time string 4 minutes ago
    result = formatDateTime(
        DateTime.now().subtract(Duration(minutes: 4)).toIso8601String());
    // Check that the function returned '4m'
    expect(result, equals('4m'));

    // Call the function with a date-time string 5 seconds ago
    result = formatDateTime(
        DateTime.now().subtract(Duration(seconds: 5)).toIso8601String());
    // Check that the function returned '5s'
    expect(result, equals('5s'));
  });
}
