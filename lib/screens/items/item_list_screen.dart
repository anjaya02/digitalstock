import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/item.dart';
import '../../providers/item_provider.dart';
import '../../ui/design_system.dart';
import 'add_products_screen.dart'; 

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  String _search = '';
  Item? _selected;                 // tapped row
  String _stockSort = 'None';      // None / Low → High / High → Low
  String _category = 'All';        

  // ────────────────────────── helpers ──────────────────────────
  List<Item> _applyFilters(List<Item> source) {
    var out = source;
    if (_search.isNotEmpty) {
      out = out
          .where((i) => i.name.toLowerCase().contains(_search.toLowerCase()))
          .toList();
    }
    switch (_stockSort) {
      case 'Low':
        out.sort((a, b) => a.stock.compareTo(b.stock));
        break;
      case 'High':
        out.sort((a, b) => b.stock.compareTo(a.stock));
        break;
    }
    // Category filter would go here once Item has category
    return out;
  }

  Future<void> _openAddItem([Item? existing]) async {
    // Push the re-usable AddProductScreen; await result to refresh list
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddProductScreen(existing: existing)),
    );
    setState(() => _selected = null);
  }

  Future<void> _adjustStockDialog(Item item) async {
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, int.tryParse(ctrl.text.trim())),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newStock != null) {
      context.read<ItemProvider>().updateStock(item.id, newStock);
      setState(() => _selected = null);
    }
  }

  // ───────────────────────────── UI ─────────────────────────────
  @override
  Widget build(BuildContext context) {
    final items = _applyFilters(context.watch<ItemProvider>().items);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 28),
            onPressed: _openAddItem,     
          )
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: Row(
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _category,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('Category')),
                    ],
                    onChanged: (_) {},
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _stockSort,
                    items: const [
                      DropdownMenuItem(value: 'None', child: Text('Stock')),
                      DropdownMenuItem(value: 'Low',  child: Text('Low → High')),
                      DropdownMenuItem(value: 'High', child: Text('High → Low')),
                    ],
                    onChanged: (v) => setState(() => _stockSort = v!),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (_, i) {
                final it = items[i];
                final selected = _selected == it;
                return InkWell(
                  onTap: () => setState(() => _selected = selected ? null : it),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(it.name,
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text('Stock: ${it.stock}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Text('Rs. ${it.price.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                );
              },
            ),
          ),

          // Row of Edit / Adjust (enabled when row selected)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selected == null
                        ? null
                        : () => _openAddItem(_selected), 
                    child: const Text('Edit item'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selected == null
                        ? null
                        : () => _adjustStockDialog(_selected!),
                    child: const Text('Adjust stock'),
                  ),
                ),
              ],
            ),
          ),
          // Big add-new button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FilledButton(
              onPressed: _openAddItem,
              child: const Text('Add new item'),
            ),
          ),
          const SizedBox(height: 12),
          // Reminder line
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Items can still be sold even with zero stock',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
