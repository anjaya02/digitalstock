import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/item_provider.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<ItemProvider>().items;

    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final item = items[i];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('Rs. ${item.price.toStringAsFixed(2)} | Stock: ${item.stock}'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // future: go to item detail/edit
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add item logic later
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
