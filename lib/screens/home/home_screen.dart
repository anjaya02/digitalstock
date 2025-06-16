import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/payment_method.dart';
import '../../providers/sale_provider.dart';
import '../../routes/app_routes.dart';
import '../../ui/design_system.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // soft caps
  static const double kLkrCap   = 100000; // LKR / month
  static const int    kItemCap  = 1000;   // items / month

  @override
  Widget build(BuildContext context) {
    final saleProv = context.watch<SaleProvider>();

    final double todaySales = saleProv.todayTotal;
    final int itemsSoldToday = saleProv.sales.fold<int>(
        0, (sum, s) => sum + s.items.fold(0, (n, i) => n + i.qty));

    final pmMap = saleProv.todayByMethod;

    // Fake usage for demo — you’d calculate this from persistence
    final double usagePercent =
        todaySales / kLkrCap; // 0.0 – 1.0 (simplified)

    return Scaffold(
      appBar: AppBar(
        title: const Text('DigitalStock'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.settings),
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            DS.summaryCard("Today’s Sales",
                "Rs ${todaySales.toStringAsFixed(0)}"),
            const SizedBox(height: 24),
            DS.summaryCard("Items Sold", "$itemsSoldToday"),
            const SizedBox(height: 40),

            Text('Payment Methods',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),

            // Payment boxes
            DS.outlineBox("Cash",
                "Rs ${pmMap[PaymentMethod.cash]!.toStringAsFixed(0)}"),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DS.outlineBox("QR",
                      "Rs ${pmMap[PaymentMethod.lankaQr]!.toStringAsFixed(0)}"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DS.outlineBox("Card",
                      "Rs ${pmMap[PaymentMethod.card]!.toStringAsFixed(0)}"),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Actions row 1
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.realtimeSale),
                    child: const Text('New Sale'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.endOfDay),
                    child: const Text('End-of-Day Entry'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Actions row 2
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.reports),
                    child: const Text('Reports'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.items),
                    child: const Text('Items'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Usage-limit warning
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
                    Text('Nearing Usage Limit',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(
                      "You've used ${(usagePercent * 100).toStringAsFixed(0)}% "
                      "of your monthly limit.\nUpgrade to continue using "
                      "DigitalStock.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {}, // TODO: open upgrade screen
                      child: const Text('Upgrade'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),

      // Bottom-nav skeleton (unchanged logic)
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.receipt), label: 'Sales'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Customers'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedIndex: 0,
        onDestinationSelected: (i) {
          // TODO: navigate to tabs when implemented
        },
      ),
    );
  }
}
