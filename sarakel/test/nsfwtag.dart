import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/home/widgets/nsfw.dart';

void main() {
  testWidgets('NSFWButton Widget Test', (WidgetTester tester) async {
    // Create the NSFWButton widget
    const widget = MaterialApp(
      home: NSFWButton(isNSFW: true),
    );

    // Add the widget to the widget tester
    await tester.pumpWidget(widget);

    // Check if the NSFWButton widget is in the widget tree
    expect(find.byType(NSFWButton), findsOneWidget);

    // Check if the ElevatedButton is in the widget tree
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Check if the Text widget with 'NSFW' is in the widget tree
    expect(find.text('NSFW'), findsOneWidget);
  });
}
