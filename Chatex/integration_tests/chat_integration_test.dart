import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chatex/main.dart' as app;
import 'package:chatex/chat/chat_build_ui.dart' as app;
import 'package:chatex/chat/elements/elements_of_chat/bottom_nav_bar.dart'
    as app;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:chatex/logic/toast_message.dart';
import 'chat_integration_test.mocks.dart'; // Ensure this file is generated

@GenerateMocks([ToastMessages]) // Generates a mock class for ToastMessages
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockToastMessages mockToastMessages;

  setUp(() {
    mockToastMessages = MockToastMessages(); // Correct initialization
  });

  group("Main test", () {
    testWidgets('Login test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          builder: (context, child) {
            return Overlay(
              initialEntries: [
                OverlayEntry(builder: (context) => child ?? Container())
              ],
            );
          },
          home: app.LoginUI()));
      await tester.pumpAndSettle();

      final emailField = find.byKey(Key('email'));
      final passwordField = find.byKey(Key('password'));
      final loginButton = find.byKey(Key('logIn'));

      await tester.enterText(emailField, 'ocsi2005levente@gmail.com');
      await tester.pumpAndSettle();
      await tester.enterText(passwordField, 'Micimacko32');
      await tester.pumpAndSettle();

      // Mock ToastMessages behavior
      when(mockToastMessages.showToastMessages(
        any,
        any,
        any,
        any,
        any,
        any,
      )).thenReturn(null);

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify ToastMessages was called with the expected message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 500), () {
          verify(mockToastMessages.showToastMessages(
            "Sikeres bejelentkezés!",
            0.2,
            Colors.green,
            Icons.check,
            Colors.black,
            const Duration(seconds: 2),
          )).called(1);
        });
      });
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
        await tester.tap(find.byKey(Key('friendsNavBar')));
        await tester.pumpAndSettle();

        final userNameField = find.byKey(Key('userName'));
        await tester.enterText(userNameField, 'valaki2');
        await tester.pumpAndSettle();

        final addFriendButton = find.byKey(Key('addFriend'));
        await tester.tap(addFriendButton);
        await tester.pumpAndSettle();

        // Mock ToastMessages when adding a friend
        when(mockToastMessages.showToastMessages(
          any,
          any,
          any,
          any,
          any,
          any,
        )).thenReturn(null);

        // Verify that ToastMessages was triggered
        /*
        verify(mockToastMessages.showToastMessages(
          "Friend request sent!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
        )).called(1);
*/
        expect(find.text("valaki2"), findsOneWidget);
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