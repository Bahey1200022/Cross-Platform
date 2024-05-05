import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/chatting/card.dart';

void main() {
  testWidgets('ChatTile Widget Test', (WidgetTester tester) async {
    // Create the ChatTile widget
    const widget = MaterialApp(
      home: Scaffold(
        body: ChatTile(
          person: 'Test Person',
          content: 'Test Content',
          profilePicture: 'assets/avatar_logo.jpeg',
          isSender: false,
        ),
      ),
    );

    // Add the widget to the widget tester
    await tester.pumpWidget(widget);

    // Check if the ChatTile widget is in the widget tree
    expect(find.byType(ChatTile), findsOneWidget);

    // Check if the person's name and content are displayed
    expect(find.text('Test Person'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);
  });
}
