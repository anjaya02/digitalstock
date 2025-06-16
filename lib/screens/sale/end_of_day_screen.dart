import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/payment_method.dart';
import '../../../models/sale.dart';
import '../../../providers/item_provider.dart';
import '../../../providers/sale_provider.dart';
import '../../../ui/design_system.dart';

class EndOfDayScreen extends StatefulWidget {
  const EndOfDayScreen({super.key});

  @override
  State<EndOfDayScreen> createState() => _EndOfDayScreenState();
}

class _EndOfDayScreenState extends State<EndOfDayScreen> {
  late Map<String, int> qtyMap;
  PaymentMethod _method = PaymentMethod.cash;

  @override
  void initState() {
    super.initState();
    final items = context.read<ItemProvider>().items;
    qtyMap = {for (var it in items) it.id: 0};
  }

  @override
  Widget build(BuildContext context) {
    final items = context.watch<ItemProvider>().items;

    return Scaffold(
      appBar: AppBar(title: const Text('End-of-Day Entry')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final item = items[i];
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: DS.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(child: Text(item.name)),
                SizedBox(
                  width: 80,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: '0'),
                    onChanged: (v) =>
                        qtyMap[item.id] = int.tryParse(v) ?? 0,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            children: [
              DropdownButton<PaymentMethod>(
                value: _method,
                items: PaymentMethod.values
                    .map((m) => DropdownMenuItem(
                          value: m,
                          child: Text(m.name.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (m) => setState(() => _method = m!),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  final saleItems = qtyMap.entries
                      .where((e) => e.value > 0)
                      .map((e) {
                    final item =
                        items.firstWhere((it) => it.id == e.key);
                    return SaleItem(item: item, qty: e.value);
                  }).toList();
                  if (saleItems.isNotEmpty) {
                    context
                        .read<SaleProvider>()
                        .addSale(Sale(method: _method, items: saleItems));
                  }
                  Navigator.pop(context);
                },
                child: const Text('Submit Day'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
