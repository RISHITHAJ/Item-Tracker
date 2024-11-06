import 'package:flutter_test/flutter_test.dart';
import 'package:item_tracker/item_provider.dart';



void main() {
  group('ItemProvider Tests', () {
    late ItemProvider itemProvider;

    setUp(() {
      itemProvider = ItemProvider();
    });

    test('Initial items should be empty', () {
      expect(itemProvider.items.length, 0);
    });

    test('Add an item', () {
      itemProvider.addItem('Item 1', 'Description 1');
      expect(itemProvider.items.length, 1);
      expect(itemProvider.items[0].name, 'Item 1');
    });

    test('Edit an item', () {
      itemProvider.addItem('Item 1', 'Description 1');
      itemProvider.editItem(0, 'Item 1 Updated', 'Description Updated');
      expect(itemProvider.items[0].name, 'Item 1 Updated');
      expect(itemProvider.items[0].description, 'Description Updated');
    });

    test('Remove an item', () {
      itemProvider.addItem('Item 1', 'Description 1');
      itemProvider.removeItem(0);
      expect(itemProvider.items.length, 0);
    });
  });
}
