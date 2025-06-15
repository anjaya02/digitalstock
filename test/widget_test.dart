import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos/app.dart'; 

void main() {
  testWidgets('App loads and builds correctly', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const DigitalStockApp());

    // OPTIONAL: Update the below lines based on your real UI
    // For now, let's just check if the home screen title or a button exists

    expect(find.byType(MaterialApp), findsOneWidget);
    // You can also check for your home screen content (e.g., a Text widget)
    // expect(find.text('Total Sales Today'), findsOneWidget); // Uncomment and adjust
  });
}
