import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/payment_method.dart';
import '../../providers/sale_provider.dart';
import '../../ui/design_system.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double kLkrCap = 100_000;

  @override
  Widget build(BuildContext context) {
    final saleProv = context.watch<SaleProvider>();
    final todaySales = saleProv.todayTotal;
    final itemsSold = saleProv.sales.fold<int>(
      0,
      (sum, s) => sum + s.items.fold(0, (n, i) => n + i.qty),
    );
    final pm = saleProv.todayByMethod;
    final usagePercent = todaySales / kLkrCap;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DigitalStock'),
        actions: [
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            DS.summaryCard(
              'Today’s Sales',
              'Rs ${todaySales.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 24),
            DS.summaryCard('Items Sold', '$itemsSold'),
            const SizedBox(height: 40),

            Text(
              'Payment Methods',
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            DS.outlineBox(
              'Cash',
              'Rs ${pm[PaymentMethod.cash]!.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DS.outlineBox(
                    'QR',
                    'Rs ${pm[PaymentMethod.lankaQr]!.toStringAsFixed(0)}',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DS.outlineBox(
                    'Card',
                    'Rs ${pm[PaymentMethod.card]!.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            if (usagePercent >= .8)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: DS.outline),
                  borderRadius: const BorderRadius.all(DS.radius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nearing Usage Limit',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You've used ${(usagePercent * 100).toStringAsFixed(0)}% "
                      "of your monthly limit.\nUpgrade to continue using DigitalStock.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {},
                      child: const Text('Upgrade'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
