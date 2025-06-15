import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sale_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = context.watch<SaleProvider>().totalSales;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DigitalStock Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total Sales Today: LKR ${total.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<SaleProvider>().addSale(150.0);
              },
              child: const Text('Simulate Sale'),
            ),
          ],
        ),
      ),
    );
  }
}
