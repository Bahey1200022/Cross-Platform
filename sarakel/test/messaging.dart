import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sarakel/Widgets/inbox/compose.dart';

void main() {
  testWidgets('Compose Widget Test', (WidgetTester tester) async {
    // Create the Compose widget
    const widget = MaterialApp(
      home: Compose(token: 'Test Token'),
    );

    // Add the widget to the widget tester
    await tester.pumpWidget(widget);

    // Check if the Compose widget is in the widget tree
    expect(find.byType(Compose), findsOneWidget);

    // Check if the TextFields are in the widget tree
    expect(find.byType(TextField), findsNWidgets(3));
  });
}
