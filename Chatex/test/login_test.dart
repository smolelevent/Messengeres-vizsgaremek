import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatex/main.dart' as app;
import 'package:chatex/auth.dart' as app;

void main() {
  testWidgets('Login with incorrect credentials test',
      (WidgetTester tester) async {
    app.main();
    app.AuthService();
    await tester.pumpWidget(app.LoginUI());
    await tester.pumpAndSettle();

    // Find the email and password text fields
    final emailField = find.byKey(Key('email'));
    final passwordField = find.byKey(Key('password'));
    final loginButton = find.byKey(Key('logIn'));

    // Enter incorrect text into the email and password fields
    await tester.enterText(emailField, 'wrongemail@example.com');
    await tester.enterText(passwordField, 'wrongpassword');

    // Tap the login button
    await tester.tap(loginButton);

    // Wait for the login process to complete
    await tester.pumpAndSettle();

    await Future.delayed(Duration(seconds: 1));
    await tester.pumpAndSettle();
    // Verify that the login failed by checking for an error message or the absence of a successful login indicator
    expect(find.text('Hibás email vagy jelszó!'), findsOne);
  });
}
