// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatex/chat/chat.dart'; // Replace with actual import
//import 'package:mockito/mockito.dart';

void main() {
  testWidgets('Chat screen sends a message', (WidgetTester tester) async {
    // Load the ChatScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: ChatUI(), // Replace with your actual screen
      ),
    );

    // Find the TextField and enter a message
    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, 'Hello, Flutter!');

    // Tap the send button
    final sendButtonFinder = find.byIcon(Icons.send);
    await tester.tap(sendButtonFinder);

    // Rebuild the widget
    await tester.pump();

    // Check if the message appears in the chat list
    expect(find.text('Hello, Flutter!'), findsOneWidget);
  });
}
