import 'package:chatex/application/components_of_ui/people.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chatex/main.dart' as app;
import 'package:chatex/application/components_of_chat/build_ui.dart' as app;
import 'package:chatex/application/components_of_ui/bottom_nav_bar.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Main test", () {
    //WidgetTester a típusa
    testWidgets('Login test', (tester) async {
      // Initialize the app with the LoginUI

      await tester.pumpWidget(const MaterialApp(home: app.LoginUI()));
      await tester.pumpAndSettle();

      // Find the email and password text fields
      final emailField = find.byKey(const Key('email'));
      final passwordField = find.byKey(const Key('password'));
      final loginButton = find.byKey(const Key('logIn'));

      // Enter text into the email and password fields
      await tester.enterText(emailField, 'ocsi2005levente@gmail.com');
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, 'Micimacko32');
      await tester.pumpAndSettle();

      // Tap the login button
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify that the login was successful by checking for a widget in the next screen
      expect(find.byType(app.ChatUI), findsOneWidget);
    });

    group("Add people test", () {
      //WidgetTester a típusa
      testWidgets('FindValaki test', (tester) async {
        int selectedIndex = 1;
        void onItemTapped(int index) {
          selectedIndex = index;
        }

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  const Expanded(
                    child: app.People(), // Include the People widget
                  ),
                  app.BottomNavbarForChat(
                    selectedIndex: selectedIndex,
                    onItemTapped: onItemTapped,
                  ),
                ],
              ),
            ),
          ),
        );
        // Initialize the app with the ChatUI and BottomNavbarForChat
        await tester.pumpAndSettle();

        // Tap the Friends tab
        final friendsTab = find.byKey(const Key('friendsNavBar'));
        expect(friendsTab, findsOneWidget);
        await tester.tap(friendsTab);
        await tester.pumpAndSettle();

        // Enter text into the search field
        final userNameField = find.byKey(const Key('userName'));
        expect(userNameField, findsOneWidget);
        await tester.enterText(userNameField, 'valaki2');
        await tester.pumpAndSettle();

        // Tap the Add Friend button
        final addFriendButton = find.byKey(const Key('addFriend'));
        expect(addFriendButton, findsOneWidget);
        await tester.tap(addFriendButton);
        await tester.pumpAndSettle();

        // Verify that the friend request was sent by checking for a success message
        expect(find.text("Friend request sent!"), findsOneWidget);
      });
    });
  });
}
