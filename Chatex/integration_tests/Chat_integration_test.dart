import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chatex/main.dart' as app;
//import 'package:chatex/chat/chat_auth/chat_auth.dart' as app;
//import 'package:chatex/chat/elements/people.dart' as app;
import 'package:chatex/chat/chat_build_ui.dart' as app;
import 'package:chatex/chat/elements/bottom_nav_bar.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("Main test", () {
    testWidgets('Login test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: app.LoginUI()));
      await tester.pumpAndSettle();

      // Find the email and password text fields
      final emailField = find.byKey(Key('email'));
      final passwordField = find.byKey(Key('password'));
      final loginButton = find.byKey(Key('logIn'));

      // Enter text into the email and password fields
      await tester.enterText(emailField, 'ocsi2005levente@gmail.com');
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, 'Micimacko32');
      await tester.pumpAndSettle();
      await tester.pump();
      await tester.pumpAndSettle();
      // Tap the login button
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
    });
    group("Add people test", () {
      testWidgets('FindValaki test', (WidgetTester tester) async {
        int selectedIndex = 1;
        void onItemTapped(int index) {
          selectedIndex = index;
        }

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: app.ChatUI(),
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: app.BottomNavbarForChat(
                selectedIndex: selectedIndex,
                onItemTapped: onItemTapped,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(Key('friendsNavBar')), findsOneWidget);
        await tester.tap(find.byKey(Key('friendsNavBar')));
        await tester.pumpAndSettle();
        final userNameField = find.byKey(Key('userName'));
        await tester.enterText(userNameField, 'Valaki');
        await tester.pumpAndSettle();
        final addFriendButton = find.byKey(Key('addFriend'));
        await tester.tap(addFriendButton);
        await tester.pumpAndSettle();
        expect(find.text("Valaki"), findsOneWidget);
      });
    });
  });
}
