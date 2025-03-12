import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatex/main.dart' as app;
import 'package:chatex/chat/elements/elements_of_chat/bottom_nav_bar.dart' as app;

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
    await Future.delayed(Duration(seconds: 1));

    // Navigate to the Ismerősök section
    expect(find.byKey(Key('friendsNavBar')), findsOneWidget);
    await tester.tap(find.byKey(Key('friendsNavBar')));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 1));

    // Find the search field and enter "Valaki"
    final searchField = find.byKey(Key('userName'));
    await tester.enterText(searchField, 'valaki2');
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 1));

    // Verify that the search results contain "Valaki"
    expect(find.text('valaki2'), findsOneWidget);
  });
}
