import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatex/main.dart' as app;
import 'package:chatex/chat/elements/bottom_nav_bar.dart' as app;

void main() {
  testWidgets('Search for "Valaki" in Ismerősök', (WidgetTester tester) async {
    int selectedIndex = 0;
    void onItemTapped(int index) {
      selectedIndex = index;
    }

    await tester.pumpWidget(app.BottomNavbarForChat(
        selectedIndex: selectedIndex, onItemTapped: onItemTapped));
    app.main();
    await tester.pumpAndSettle();

    // Navigate to the Ismerősök section
    final friendNavBar = find.byKey(Key('friendNavBar'));
    await tester.tap(friendNavBar);
    await tester.pumpAndSettle();

    // Find the search field and enter "Valaki"
    final searchField = find.byKey(Key('userName'));
    await tester.enterText(searchField, 'Valaki');
    await tester.pumpAndSettle();

    // Verify that the search results contain "Valaki"
    expect(find.text('Valaki'), findsOneWidget);
  });
}
