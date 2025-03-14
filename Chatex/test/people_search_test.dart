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

    // Ensure bottom navigation bar is built
    await tester.pumpAndSettle();
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Try finding the navigation button by type or icon
    final friendsTab = find.byKey(Key('friendsNavBar'));
    if (friendsTab.evaluate().isEmpty) {
      // Fallback if key is not found
      await tester
          .tap(find.byIcon(Icons.people)); // Adjust based on actual icon
    } else {
      await tester.tap(friendsTab);
    }

    await tester.pumpAndSettle();

    // Verify that the search field is present
    final searchField = find.byKey(Key('userName'));
    expect(searchField, findsOneWidget);

    // Enter search text
    await tester.enterText(searchField, 'valaki2');
    await tester.pumpAndSettle();

    // Verify the search result appears
    expect(find.text('valaki2'), findsOneWidget);
  });
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