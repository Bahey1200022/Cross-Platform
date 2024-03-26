import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sarakel/screens/entry/signup_page.dart';
import 'package:sarakel/screens/entry/welcome_page.dart'; // Add missing import statement for 'flutter/material.dart'
import 'package:sarakel/main.dart';

void main() {
  testWidgets('test_1', (WidgetTester tester) async {
    ////hello world
    await tester.pumpWidget(
        MyApp()); // Wrap WelcomePage with MaterialApp   flutter test test/test.dart
    await tester.pumpAndSettle();

    // Find the button with the email icon
    final emailButton = find.byIcon(Icons.email);
    expect(emailButton, findsOneWidget);

    // Press the email button
    await tester.tap(emailButton);
    await tester.pumpAndSettle();
  });

  testWidgets('invalid signup', (WidgetTester tester) async {
    ///////invalid signup
    await tester.pumpWidget(MaterialApp(
        home:
            SignupPage())); // Wrap WelcomePage with MaterialApp   flutter test test/test.dart
    await tester.pumpAndSettle();

    // Find the text field of the username
    final email = find.byType(TextField).first;
    // expect(email, findsOneWidget);
    final pass = find.byType(TextField).last;
    // Enter a username
    await tester.enterText(email, 'kmail.com');
    await tester.enterText(pass, '1234567890');
    // Find the button with the signup text
    final signupButton = find.text('Continue');

    // Press the signup button
    await tester.tap(signupButton);
    await tester.pumpAndSettle();
    // Check if the error pop-up message appears
    final errorPopUp = find.text('Error');
    expect(errorPopUp, findsOneWidget);
  });

  ///sucessful signup
  testWidgets('sucessful signup', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home:
            SignupPage())); // Wrap WelcomePage with MaterialApp   flutter test test/test.dart
    await tester.pumpAndSettle();

    // Find the text field of the username
    final email = find.byType(TextField).first;
    // expect(email, findsOneWidget);
    final pass = find.byType(TextField).last;
    // Enter a username
    await tester.enterText(email, 'hafez@gmail.com');
    await tester.enterText(pass, '1234567890');
    // Find the button with the signup text
    final signupButton = find.text('Continue');

    // Press the signup button
    await tester.tap(signupButton);
    await tester.pumpAndSettle();
    // Check if the error pop-up message appears
    final UserNamePage = find.text('Create your username');
    expect(UserNamePage, findsOneWidget);
  });
}
