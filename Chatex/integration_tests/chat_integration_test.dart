import 'package:chatex/chat/elements/elements_of_chat/people.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chatex/main.dart' as app;
import 'package:chatex/chat/chat_build_ui.dart' as app;
import 'package:chatex/chat/elements/elements_of_chat/bottom_nav_bar.dart'
    as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Main test", () {
    testWidgets('Login test', (WidgetTester tester) async {
      // Initialize the app with the LoginUI

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

      // Tap the login button
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify that the login was successful by checking for a widget in the next screen
      expect(find.byType(app.ChatUI), findsOneWidget);
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
              body: Column(
                children: [
                  Expanded(
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
        final friendsTab = find.byKey(Key('friendsNavBar'));
        expect(friendsTab, findsOneWidget);
        await tester.tap(friendsTab);
        await tester.pumpAndSettle();

        // Enter text into the search field
        final userNameField = find.byKey(Key('userName'));
        expect(userNameField, findsOneWidget);
        await tester.enterText(userNameField, 'valaki2');
        await tester.pumpAndSettle();

        // Tap the Add Friend button
        final addFriendButton = find.byKey(Key('addFriend'));
        expect(addFriendButton, findsOneWidget);
        await tester.tap(addFriendButton);
        await tester.pumpAndSettle();

        // Verify that the friend request was sent by checking for a success message
        expect(find.text("Friend request sent!"), findsOneWidget);
      });
    });
  });
}


/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chatex/main.dart' as app;
import 'package:chatex/chat/chat_build_ui.dart' as app;
import 'package:chatex/chat/elements/elements_of_chat/bottom_nav_bar.dart'
    as app;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'chat_integration_test.mocks.dart'; // Import the generated mock

@GenerateMocks([Fluttertoast]) // Generates a mock class
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockFluttertoast mockToast;

  setUp(() {
    mockToast = MockFluttertoast(); // Initialize mock toast
  });

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

      // Mock Fluttertoast behavior
      when(mockToast.showToast(
        msg: anyNamed('msg'),
        toastLength: anyNamed('toastLength'),
        gravity: anyNamed('gravity'),
        timeInSecForIosWeb: anyNamed('timeInSecForIosWeb'),
        backgroundColor: anyNamed('backgroundColor'),
        textColor: anyNamed('textColor'),
        fontSize: anyNamed('fontSize'),
      )).thenAnswer((_) async => true);

      // Tap the login button
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify Fluttertoast was called with a specific message
      verify(mockToast.showToast(
        msg: "Login successful!", // Adjust this based on your app's logic
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: anyNamed('backgroundColor'),
        textColor: anyNamed('textColor'),
        fontSize: anyNamed('fontSize'),
      )).called(1);
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
        await tester.enterText(userNameField, 'valaki2');
        await tester.pumpAndSettle();

        final addFriendButton = find.byKey(Key('addFriend'));
        await tester.tap(addFriendButton);
        await tester.pumpAndSettle();

        // Mock Fluttertoast when adding a friend
        when(mockToast.showToast(
          msg: anyNamed('msg'),
          toastLength: anyNamed('toastLength'),
          gravity: anyNamed('gravity'),
          timeInSecForIosWeb: anyNamed('timeInSecForIosWeb'),
          backgroundColor: anyNamed('backgroundColor'),
          textColor: anyNamed('textColor'),
          fontSize: anyNamed('fontSize'),
        )).thenAnswer((_) async => true);

        // Verify that Fluttertoast was triggered
        verify(mockToast.showToast(
          msg: "Friend request sent!", // Adjust based on your app
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: anyNamed('backgroundColor'),
          textColor: anyNamed('textColor'),
          fontSize: anyNamed('fontSize'),
        )).called(1);

        expect(find.text("valaki2"), findsOneWidget);
      });
    });
  });
}
*/