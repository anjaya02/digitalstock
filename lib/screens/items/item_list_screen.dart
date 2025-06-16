import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/item_provider.dart';
import '../../ui/design_system.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<ItemProvider>().items;

    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) {
          final item = items[i];
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DS.cardBG,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(item.name,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                Text('Rs. ${item.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 12),
                Text('Stock: ${item.stock}',
                    style: Theme.of(context).textTheme.bodySmall),
                const Icon(Icons.chevron_right),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add item logic
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
