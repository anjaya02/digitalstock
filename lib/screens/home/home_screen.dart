import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sale_provider.dart';
import '../../routes/app_routes.dart';
import '../../ui/design_system.dart';
import '../../models/payment_method.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final saleProv = context.watch<SaleProvider>();
    final total    = saleProv.todayTotal;
    final items    = saleProv.sales.fold<int>(
        0, (sum, s) => sum + s.items.fold(0, (n, i) => n + i.qty));
    final pm       = saleProv.todayByMethod;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            DS.summaryCard("Today’s Sales", "LKR ${total.toStringAsFixed(0)}"),
            const SizedBox(height: 16),
            DS.summaryCard("Items Sold", "$items"),
            const SizedBox(height: 32),

            Text('Payment Methods',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                DS.paymentBox("Cash",
                    "LKR ${pm[PaymentMethod.cash]!.toStringAsFixed(0)}"),
                DS.paymentBox("QR",
                    "LKR ${pm[PaymentMethod.lankaQr]!.toStringAsFixed(0)}"),
                DS.paymentBox("Card",
                    "LKR ${pm[PaymentMethod.card]!.toStringAsFixed(0)}"),
              ],
            ),

            const SizedBox(height: 32),
            Text('Actions',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.realtimeSale),
              child: const Text('New Sale'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.endOfDay),
              child: const Text('End-of-Day Entry'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.reports),
              child: const Text('Reports'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.items),
              child: const Text('Items'),
            ),
          ],
        ),
      ),

      // Simple bottom-nav placeholder
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.receipt), label: 'Sales'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Customers'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedIndex: 0,
        onDestinationSelected: (i) {
          // hook up later
        },
      ),
    );
  }
}
