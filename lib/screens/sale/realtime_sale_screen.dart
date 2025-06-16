import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/payment_method.dart';
import '../../../models/sale.dart';
import '../../../providers/item_provider.dart';
import '../../../providers/sale_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../ui/design_system.dart';

class RealTimeSaleScreen extends StatefulWidget {
  const RealTimeSaleScreen({super.key});

  @override
  State<RealTimeSaleScreen> createState() => _RealTimeSaleScreenState();
}

class _RealTimeSaleScreenState extends State<RealTimeSaleScreen> {
  final List<SaleItem> _basket = [];
  PaymentMethod _method = PaymentMethod.cash;
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final items = context
        .watch<ItemProvider>()
        .items
        .where((i) =>
            _search.isEmpty || i.name.toLowerCase().contains(_search))
        .toList();

    final subtotal =
        _basket.fold(0.0, (sum, sItem) => sum + sItem.lineTotal);

    return Scaffold(
      appBar: AppBar(title: const Text('New Sale')),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search or scan',
              ),
              onChanged: (q) => setState(() => _search = q.toLowerCase()),
            ),
          ),

          // Item list
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                return ListTile(
                  title: Text(item.name),
                  subtitle:
                      Text('Rs. ${item.price.toStringAsFixed(2)}'),
                  onTap: () {
                    setState(() {
                      _basket.add(SaleItem(item: item));
                    });
                  },
                );
              },
            ),
          ),

          // Basket
          if (_basket.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: DS.cardBG,
                borderRadius: BorderRadius.vertical(top: DS.radius),
              ),
              child: Column(
                children: [
                  ..._basket.map((s) => ListTile(
                        title: Text(s.item.name),
                        trailing: Text(
                            'x${s.qty} = Rs.${s.lineTotal.toStringAsFixed(2)}'),
                        onTap: () => setState(() => s.qty++),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text('Subtotal: Rs. ${subtotal.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium),
                      FilledButton(
                        onPressed: () {
                          final sale =
                              Sale(method: _method, items: _basket);
                          context.read<SaleProvider>().addSale(sale);
                          Navigator.pushNamed(context, AppRoutes.payment,
                              arguments: sale);
                        },
                        child: const Text('Complete'),
                      )
                    ],
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
