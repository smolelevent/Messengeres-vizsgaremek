import 'package:chatex/application/elements/elements_of_chat/bottom_nav_bar.dart'
    as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:chatex/main.dart' as app;
//import 'package:chatex/chat/chat_build_ui.dart' as app;
import 'package:chatex/application/elements/elements_of_chat/people.dart'
    as app;

void main() {
  testWidgets('FindValaki test', (tester) async {
    //WidgetTester a tipusa
    int selectedIndex = 1;
    void onItemTapped(int index) {
      selectedIndex = index;
    }

    // Initialize the widget tree
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

    // Wait for UI updates
    await tester.pumpAndSettle();

    // Debugging: Print the widget tree
    debugPrint(tester.allWidgets.toStringDeep());

    // Try finding the Friends tab
    final friendsTab = find.byKey(const Key('friendsNavBar'));
    expect(friendsTab, findsOneWidget,
        reason: 'The friendsNavBar key is missing in the widget tree.');

    // Tap the Friends tab
    await tester.tap(friendsTab);
    await tester.pumpAndSettle();

    // Verify that the search field exists
    await tester.ensureVisible(find.byKey(const Key('userName')));
    final userNameField = find.byKey(const Key('userName'));
    expect(userNameField, findsOneWidget);

    // Enter search text
    await tester.enterText(userNameField, 'valaki2');
    await tester.pumpAndSettle();
  });
}

extension on Iterable<Widget> {
  String? toStringDeep() {
    return null;
  }
}


/*
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatex/main.dart' as app;
import 'package:chatex/chat/elements/elements_of_chat/bottom_nav_bar.dart'
    as app;

void main() {
  testWidgets('Search for "valaki2" in Ismerősök', (WidgetTester tester) async {
    int selectedIndex = 0;
    void onItemTapped(int index) {
      selectedIndex = index;
    }

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
    await tester.pumpWidget(MaterialApp(home: app.LoginUI()));
    await tester.pumpAndSettle();

    // Navigate to the Ismerősök section
    expect(find.byKey(Key('friendsNavBar')), findsOneWidget);
    await tester.tap(find.byKey(Key('friendsNavBar')));
    await tester.pumpAndSettle();

    // Find the search field and enter "valaki2"
    Future.delayed(Duration(milliseconds: 500), () async {
      final searchField = find.byKey(Key('userName'));
      await tester.enterText(searchField, 'valaki2');
      await tester.pumpAndSettle();
    });

    // Verify that the search results contain "Valaki"
    expect(find.text('valaki2'), findsOneWidget);
  });
}
*/