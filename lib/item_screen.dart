import 'package:flutter/material.dart';
import 'package:item_tracker/item.dart';
import 'package:provider/provider.dart';
import 'item_provider.dart';
import 'edit_item_screen.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Item Tracker',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditItemScreen()),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: isWideScreen
                ? _buildGridView(itemProvider)
                : _buildListView(itemProvider),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditItemScreen()),
        ),
      ),
    );
  }

  // Grid View for larger screens
  Widget _buildGridView(ItemProvider itemProvider) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two items per row for larger screens
        childAspectRatio: 7/2, // Adjust aspect ratio for layout
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: itemProvider.items.length,
      itemBuilder: (context, index) {
        final item = itemProvider.items[index];
        return _buildItemCard(context, item, index);
      },
    );
  }

  // List View for smaller screens
  Widget _buildListView(ItemProvider itemProvider) {
    return ListView.builder(
      itemCount: itemProvider.items.length,
      itemBuilder: (context, index) {
        final item = itemProvider.items[index];
        return _buildItemCard(context, item, index);
      },
    );
  }

  // Common card layout for both ListView and GridView
  Widget _buildItemCard(BuildContext context, Item item, int index) {
    final itemProvider = Provider.of<ItemProvider>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(item.description),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => itemProvider.removeItem(index),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditItemScreen(itemIndex: index)),
        ),
      ),
    );
  }
}
