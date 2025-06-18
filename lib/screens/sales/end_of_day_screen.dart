import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/item.dart';
import '../../models/payment_method.dart';
import '../../models/sale.dart';
import '../../providers/item_provider.dart';
import '../../providers/sale_provider.dart';
import '../../ui/design_system.dart';

class EndOfDayScreen extends StatefulWidget {
  const EndOfDayScreen({super.key});

  @override
  State<EndOfDayScreen> createState() => _EndOfDayScreenState();
}

class _EndOfDayScreenState extends State<EndOfDayScreen> {
  late final List<Item> _items;
  late final Map<Item, int> _qty; // per-item counts
  PaymentMethod _method = PaymentMethod.cash;
  bool _loadingDraft = true;

  // ───────────────────────── draft ─────────────────────────
  @override
  void initState() {
    super.initState();
    _items = context.read<ItemProvider>().items;
    _qty = {for (final it in _items) it: 0};
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('eod_draft');
    if (raw != null) {
      final saved = json.decode(raw) as Map<String, dynamic>;
      for (final entry in saved.entries) {
        final item = _items.firstWhere(
          (i) => i.id == entry.key,
          orElse: () => Item(id: '', name: '', price: 0),
        );
        if (item.id.isNotEmpty) _qty[item] = entry.value as int;
      }
    }
    setState(() => _loadingDraft = false);
  }

  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final map = {
      for (final e in _qty.entries)
        if (e.value > 0) e.key.id: e.value,
    };
    await prefs.setString('eod_draft', json.encode(map));
  }

  Future<void> _clearDraft() async =>
      (await SharedPreferences.getInstance()).remove('eod_draft');

  // ───────────────────── qty helpers ─────────────────────
  void _inc(Item it) => setState(() => _qty[it] = _qty[it]! + 1);
  void _dec(Item it) =>
      setState(() => _qty[it] = _qty[it]! > 0 ? _qty[it]! - 1 : 0);

  bool get _hasChanges => _qty.values.any((v) => v > 0);

  // ─────────────────── payment picker ───────────────────
  Future<void> _selectMethod() async {
    final chosen = await showModalBottomSheet<PaymentMethod>(
      context: context,
      builder: (sheetCtx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: PaymentMethod.values
            .map(
              (m) => RadioListTile<PaymentMethod>(
                title: Text(m.name.toUpperCase()),
                value: m,
                groupValue: _method,
                onChanged: (val) => Navigator.pop(sheetCtx, val),
              ),
            )
            .toList(),
      ),
    );
    if (!mounted) return;
    if (chosen != null && chosen != _method) {
      setState(() => _method = chosen);
    }
  }

  // ─────────────────── save / submit ────────────────────
  Future<void> _submitThisMethod() async {
    final saleItems = _qty.entries
        .where((e) => e.value > 0)
        .map((e) => SaleItem(item: e.key, qty: e.value))
        .toList();

    if (saleItems.isEmpty) return;
    context.read<SaleProvider>().addSale(
      Sale(method: _method, items: saleItems),
    );

    // reset counts & draft so cashier can log next method
    _qty.updateAll((_, __) => 0);
    await _clearDraft();
    setState(() {}); // rebuild buttons
  }

  // ───────────────────────── UI ─────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_loadingDraft) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
          // ── list header ──
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

          // ── item list ──
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

          // ── payment selector ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: ElevatedButton(
              onPressed: _selectMethod,
              style: ElevatedButton.styleFrom(
                backgroundColor: DS.cardGrey,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: Text(_method.name.toUpperCase()),
            ),
          ),

          // ── action buttons ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _hasChanges ? () => _saveDraft() : null,
                  child: const Text('Save Progress'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _hasChanges ? _submitThisMethod : null,
                  child: const Text('Submit This Method'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Repeat for each payment type you accepted today.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// round grey “+ / −” button
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
