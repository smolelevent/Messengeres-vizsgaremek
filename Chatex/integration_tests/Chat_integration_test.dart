import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chatex/main.dart' as app;
import 'package:chatex/chat/chat_auth/chat_auth.dart' as app;
import 'package:chatex/chat/people.dart' as app;
import 'package:chatex/chat/chat.dart' as app;
import 'package:chatex/chat/bottom_nav_bar.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Find the email and password text fields
    final emailField = find.byKey(Key('email'));
    final passwordField = find.byKey(Key('password'));
    final loginButton = find.byKey(Key('logIn'));
    final friendNavBar = find.byKey(Key('friendNavBar'));

    // Enter text into the email and password fields
    await tester.enterText(emailField, 'ocsi2005levente@gmail.com');
    await tester.enterText(passwordField, 'Micimacko326696');

    // Tap the login button
    await tester.tap(loginButton);
    
    // Wait for the login process to complete
    await tester.pumpAndSettle(); 
    // Verify that the login was successful
    
    expect(find.text('Chatek'), findsOneWidget);
    await tester.tap(friendNavBar);

    await tester.pumpAndSettle();

  });
  testWidgets('FindValaki test', (WidgetTester tester) async {
  await tester.pumpAndSettle();
  });
}
