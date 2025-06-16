import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/item.dart';
import '../../models/sale.dart';
import '../../models/payment_method.dart';
import '../../providers/item_provider.dart';
import '../../providers/sale_provider.dart';
import '../../ui/design_system.dart';

/// ─────────────────────────────────────────────────────────────────────────
///  BULK ENTRY  (end-of-day quick tally)
/// ─────────────────────────────────────────────────────────────────────────
class EndOfDayScreen extends StatefulWidget {
  const EndOfDayScreen({super.key});

  @override
  State<EndOfDayScreen> createState() => _EndOfDayScreenState();
}

class _EndOfDayScreenState extends State<EndOfDayScreen> {
  late List<Item> _items; // snapshot of all items
  late Map<Item, int> _qty; // counts
  PaymentMethod _method = PaymentMethod.cash;

  @override
  void initState() {
    super.initState();
    _items = context.read<ItemProvider>().items;
    _qty = {for (final it in _items) it: 0};
  }

  // ── helpers ────────────────────────────────────────────────────────────
  void _inc(Item it) => setState(() => _qty[it] = _qty[it]! + 1);
  void _dec(Item it) =>
      setState(() => _qty[it] = _qty[it]! > 0 ? _qty[it]! - 1 : 0);

  bool get _hasChanges => _qty.values.any((v) => v > 0);

  void _saveDay({required bool submit}) {
    if (!submit) {
      // TODO: persist draft locally (Hive/SharedPrefs)
      Navigator.pop(context);
      return;
    }

    final saleItems = _qty.entries
        .where((e) => e.value > 0)
        .map((e) => SaleItem(item: e.key, qty: e.value))
        .toList();

    if (saleItems.isNotEmpty) {
      context.read<SaleProvider>().addSale(
        Sale(method: _method, items: saleItems),
      );
    }
    Navigator.pop(context);
  }

  // ── UI ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Entry'),
        leading: IconButton(
          icon: const Icon(Icons.close, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // List header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Items',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),

          // Item list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (_, i) {
                final it = _items[i];
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            it.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rs. ${it.price.toStringAsFixed(0)}',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    _QtyButton(icon: Icons.remove, onTap: () => _dec(it)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        _qty[it].toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    _QtyButton(icon: Icons.add, onTap: () => _inc(it)),
                  ],
                );
              },
            ),
          ),

          // Bottom actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _hasChanges ? () => _saveDay(submit: false) : null,
                  child: const Text('Save Progress'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _hasChanges ? () => _saveDay(submit: true) : null,
                  child: const Text('Submit Day'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// reused grey +/- button
class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: DS.cardGrey,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.black),
      ),
    );
  }
}
