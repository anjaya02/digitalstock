import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/item.dart';
import '../../models/payment_method.dart';
import '../../models/sale.dart';
import '../../providers/item_provider.dart';
import '../../providers/sale_provider.dart';
import '../../routes/app_routes.dart';
import '../../ui/design_system.dart';

/// ─────────────────────────────────────────────────────────────────────────
///  NEW SALE  (real-time entry)
/// ─────────────────────────────────────────────────────────────────────────
class RealTimeSaleScreen extends StatefulWidget {
  const RealTimeSaleScreen({super.key});

  @override
  State<RealTimeSaleScreen> createState() => _RealTimeSaleScreenState();
}

class _RealTimeSaleScreenState extends State<RealTimeSaleScreen> {
  final Map<Item, int> _basket = {}; // item → qty
  String _search = '';
  PaymentMethod _method = PaymentMethod.cash;

  // ── helpers ────────────────────────────────────────────────────────────
  List<Item> _filteredItems(List<Item> all) {
    if (_search.isEmpty) return all;
    return all
        .where((i) => i.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  double get _subtotal =>
      _basket.entries.fold(0.0, (sum, e) => sum + e.key.price * e.value);

  int get _totalQty => _basket.values.fold<int>(0, (sum, qty) => sum + qty);

  void _addItem(Item item) =>
      setState(() => _basket[item] = (_basket[item] ?? 0) + 1);

  void _decItem(Item item) {
    if (!_basket.containsKey(item)) return;
    setState(() {
      final newQty = _basket[item]! - 1;
      if (newQty <= 0) {
        _basket.remove(item);
      } else {
        _basket[item] = newQty;
      }
    });
  }

  // ── UI ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final items = _filteredItems(context.watch<ItemProvider>().items);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sale'),
        leading: IconButton(
          icon: const Icon(Icons.close, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: DS.cardGrey,
                hintText: 'Search or scan',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (q) => setState(() => _search = q),
            ),
          ),

          // Item list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (_, i) {
                final item = items[i];
                final qty = _basket[item] ?? 0;
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '1 × ${item.price.toStringAsFixed(2)}',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    _QtyButton(icon: Icons.remove, onTap: () => _decItem(item)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        qty.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    _QtyButton(icon: Icons.add, onTap: () => _addItem(item)),
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
                Row(
                  children: [
                    // payment method grey button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // quick cycle between methods for now
                          setState(
                            () => _method =
                                PaymentMethod.values[(_method.index + 1) %
                                    PaymentMethod.values.length],
                          );
                        },
                        child: Text(_method.name.toUpperCase()),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Black complete button
                    Expanded(
                      child: FilledButton(
                        onPressed: _basket.isEmpty
                            ? null
                            : () {
                                final sale = Sale(
                                  method: _method,
                                  items: _basket.entries
                                      .map(
                                        (e) =>
                                            SaleItem(item: e.key, qty: e.value),
                                      )
                                      .toList(),
                                );

                                context.read<SaleProvider>().addSale(sale);

                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.payment,
                                  arguments: sale,
                                );
                              },
                        child: Text(
                          'Complete Sale (${_totalQty.toString()} items)',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Subtotal: ${_subtotal.toStringAsFixed(2)}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// round grey +/- button
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
