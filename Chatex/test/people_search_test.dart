import 'package:chatex/application/elements/elements_of_chat/bottom_nav_bar.dart'
    as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatex/application/elements/elements_of_chat/people.dart'
    as app;

void main() {
  testWidgets('FindValaki test', (tester) async {
    //WidgetTester a tipusa
    int selectedIndex = 1;
    void onItemTapped(int index) {
      selectedIndex = index;
    }

    // Widget tree inicializálása
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const Expanded(
                child: app.People(),
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
