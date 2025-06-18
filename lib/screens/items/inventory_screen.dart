
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/item.dart';
import '../../providers/item_provider.dart';
// import '../../routes/app_routes.dart';
import '../../ui/design_system.dart';
import 'add_products_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _search = '';

  Future<void> _adjustStockDialog(BuildContext context, Item item) async {
    final ctrl = TextEditingController(text: item.stock.toString());
    final newStock = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Adjust Stock'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'New stock value'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, int.tryParse(ctrl.text)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newStock != null) {
      context.read<ItemProvider>().updateStock(item.id, newStock);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = context.watch<ItemProvider>().items;
    final filtered = _search.isEmpty
        ? items
        : items
            .where((i) => i.name.toLowerCase().contains(_search.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddProductScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // search
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: DS.cardGrey,
                hintText: 'Search items',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (q) => setState(() => _search = q),
            ),
          ),
          // list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _ItemRow(
                item: filtered[i],
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddProductScreen(existing: filtered[i])),
                ),
                onAdjust: () => _adjustStockDialog(context, filtered[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.onEdit, required this.onAdjust});
  final Item item;
  final VoidCallback onEdit;
  final VoidCallback onAdjust;

  @override
  Widget build(BuildContext context) {
    final lowStock = item.stock <= 2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: DS.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // name + stock
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Stock: ${item.stock}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
                    if (lowStock)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'LOW',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // price
          Text('Rs ${item.price.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.inventory, size: 20),
            onPressed: onAdjust,
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: () => context.read<ItemProvider>().deleteItem(item.id),
          ),
        ],
      ),
    );
  }
}
