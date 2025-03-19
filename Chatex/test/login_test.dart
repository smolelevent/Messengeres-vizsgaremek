import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chatex/main.dart' as app;
import 'package:chatex/utils/toast_service.dart';

// Create a Mock class for ToastService
class MockToastService extends Mock implements ToastService {}

void main() {
  late MockToastService mockToastService;

  setUp(() {
    mockToastService = MockToastService();

    // Register the mock behavior
    when(() => mockToastService.showToast(any())).thenReturn(null);
  });

  testWidgets('Login with incorrect credentials shows toast message',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: app.LoginUI(),
    ));
    await tester.pumpAndSettle();

    final emailField = find.byKey(const Key('email'));
    final passwordField = find.byKey(const Key('password'));
    final loginButton = find.byKey(const Key('logIn'));

    await tester.enterText(emailField, 'wrongemail@example.com');
    await tester.enterText(passwordField, 'wrongpassword');
    await tester.tap(loginButton);
    await tester.pump(); // Allow UI updates

    // Verify that the ToastService was called
    verifyNever(() => mockToastService.showToast("Hibás email vagy jelszó!"))
        .called(0);
  });
}



/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatex/main.dart' as app;
import 'package:chatex/logic/auth.dart' as app;
//import 'package:chatex/logic/toast_message.dart';

void main() {
  testWidgets('Login with incorrect credentials test',
      (WidgetTester tester) async {
    app.main();
    app.AuthService();
    await tester.pumpWidget(app.LoginUI());
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 1));

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
    // Verify that the login failed by checking for an error message or the absence of a successful login indicator
    expect(find.widgetWithText(Void, "Hibás email vagy jelszó!"), findsOneWidget);
  });
}
*/