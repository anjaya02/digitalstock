import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/item.dart';
// import '../../models/sale.dart';
import '../../providers/sale_provider.dart';
import '../../routes/app_routes.dart';
import '../../ui/design_system.dart';

/// One-stop hub for the cashier.
class SalesHubScreen extends StatefulWidget {
  const SalesHubScreen({super.key});

  @override
  State<SalesHubScreen> createState() => _SalesHubScreenState();
}

class _SalesHubScreenState extends State<SalesHubScreen> {
  /// 0-today, 1-week, 2-month
  int _period = 0;

  // --------------------------------------------------------------------------
  List<MapEntry<Item, int>> _topItems(SaleProvider prov) {
    DateTime cutoff;
    final now = DateTime.now();
    if (_period == 0) {
      cutoff = DateTime(now.year, now.month, now.day); // midnight
    } else if (_period == 1) {
      cutoff = now.subtract(const Duration(days: 7));
    } else {
      cutoff = DateTime(now.year, now.month - 1, now.day);
    }

    final Map<Item, int> counter = {};
    for (final sale in prov.sales) {
      if (sale.timestamp.isBefore(cutoff)) continue;
      for (final sItem in sale.items) {
        counter.update(
          sItem.item,
          (v) => v + sItem.qty,
          ifAbsent: () => sItem.qty,
        );
      }
    }

    final entries = counter.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(3).toList();
  }

  Widget _periodChip(int idx, String label) {
    final selected = _period == idx;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _period = idx),
      selectedColor: Colors.black,
      backgroundColor: DS.cardGrey,
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
    );
  }

  Widget _bigBtn({
    required String text,
    required VoidCallback onTap,
    required bool primary,
  }) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: primary ? Colors.black : DS.cardGrey,
          foregroundColor: primary ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        child: Text(text),
      ),
    );
  }

  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final sales = context.watch<SaleProvider>();
    final top = _topItems(sales);

    return Scaffold(
      appBar: AppBar(title: const Text('Sales')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── big action buttons ─────────────────────────────────────────
            _bigBtn(
              text: 'New Sale',
              onTap: () => Navigator.pushNamed(context, AppRoutes.realtimeSale),
              primary: true,
            ),
            const SizedBox(height: 16),
            _bigBtn(
              text: 'End-of-Day Entry',
              onTap: () => Navigator.pushNamed(context, AppRoutes.endOfDay),
              primary: false,
            ),
            const SizedBox(height: 16),
            _bigBtn(
              text: 'Items',
              onTap: () => Navigator.pushNamed(context, AppRoutes.items),
              primary: false,
            ),

            const SizedBox(height: 32),

            // ── Top items header + period selector (fixed version) ──────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top 3 Items',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: [
                    _periodChip(0, 'Today'),
                    _periodChip(1, 'Week'),
                    _periodChip(2, 'Month'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Top list card ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: DS.cardGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: top.isEmpty
                  ? const Text(
                      'No sales yet.',
                      style: TextStyle(color: Colors.grey),
                    )
                  : Column(
                      children: top
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Expanded(child: Text(e.key.name)),
                                  Text(
                                    'x${e.value}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),

            const Spacer(),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Tip: You can still sell items even if their stock is 0.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
