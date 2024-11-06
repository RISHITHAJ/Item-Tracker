import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'item_provider.dart';
import 'package:item_tracker/item_screen.dart';

class EditItemScreen extends StatefulWidget {
  final int? itemIndex;

  const EditItemScreen({super.key, this.itemIndex});

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.itemIndex != null) {
      final item = context.read<ItemProvider>().items[widget.itemIndex!];
      _nameController.text = item.name;
      _descriptionController.text = item.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    final padding = isWideScreen ? 32.0 : 16.0;
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemIndex == null ? 'Add Item' : 'Edit Item'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWideScreen ? 600 : double.infinity,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    isWideScreen: isWideScreen,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    isWideScreen: isWideScreen,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.itemIndex == null ? 'Add' : 'Save',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: () {
                      if (_nameController.text.isNotEmpty &&
                          _descriptionController.text.isNotEmpty) {
                        if (widget.itemIndex == null) {
                          itemProvider.addItem(
                            _nameController.text,
                            _descriptionController.text,
                          );
                        } else {
                          itemProvider.editItem(
                            widget.itemIndex!,
                            _nameController.text,
                            _descriptionController.text,
                          );
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ItemScreen()), // Replace with your item list screen
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    required bool isWideScreen,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: isWideScreen ? 18 : 12,
          horizontal: 16,
        ),
      ),
    );
  }
}
