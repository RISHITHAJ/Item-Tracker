import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:item_tracker/item_provider.dart';
import 'package:item_tracker/edit_item_screen.dart';

void main() {
  testWidgets('Add Item Screen Test', (WidgetTester tester) async {
    final itemProvider = ItemProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => itemProvider,
        child: const MaterialApp(
          home: EditItemScreen(),
        ),
      ),
    );

    // Verify initial state
    expect(find.text('Add Item'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));

    // Enter name and description
    await tester.enterText(find.byType(TextField).at(0), 'Item 1');
    await tester.enterText(find.byType(TextField).at(1), 'Description 1');

    // Tap the Add button
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Verify we are back on ItemScreen
    expect(find.text('Item Tracker'), findsOneWidget);

    // Verify that the newly added item appears in the list
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Description 1'), findsOneWidget);
  });

  testWidgets('Edit Item Screen Test', (WidgetTester tester) async {
    // Create an ItemProvider with one item
    final itemProvider = ItemProvider();
    itemProvider.addItem('Item 1', 'Description 1');

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => itemProvider,
        child: const MaterialApp(
          home: EditItemScreen(itemIndex: 0),
        ),
      ),
    );

    // Verify initial state
    expect(find.text('Edit Item'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));

    // Update name and description
    await tester.enterText(find.byType(TextField).at(0), 'Item 1 Updated');
    await tester.enterText(find.byType(TextField).at(1), 'Description Updated');

    // Tap the Save button
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify that the item was updated
    expect(itemProvider.items[0].name, 'Item 1 Updated');
    expect(itemProvider.items[0].description, 'Description Updated');
  });
}
