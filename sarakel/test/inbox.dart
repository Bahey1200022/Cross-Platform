import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/inbox/message_display.dart';

void main() {
  testWidgets('inboxMessage Widget Test', (WidgetTester tester) async {
    // Create the inboxMessage widget
    final widget = MaterialApp(
      home: inboxMessage(
        recipient: 'Test Recipient',
        title: 'Test Title',
        content: 'Test Content',
        sender: 'Test Sender',
      ),
    );

    // Add the widget to the widget tester
    await tester.pumpWidget(widget);

    // Check if the inboxMessage widget is in the widget tree
    expect(find.byType(inboxMessage), findsOneWidget);

    // Check if the Text widgets are in the widget tree
    expect(find.text('From: Test Recipient'), findsOneWidget);
    expect(find.text('To: Test Sender'), findsOneWidget);
    expect(find.text(' Test Title'), findsOneWidget);
    expect(find.text(' Test Content'), findsOneWidget);
  });
}
