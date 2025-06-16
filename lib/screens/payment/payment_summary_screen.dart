// screens/payment/payment_summary_screen.dart
import 'package:flutter/material.dart';
import '../../models/sale.dart';

class PaymentSummaryScreen extends StatelessWidget {
  const PaymentSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sale = ModalRoute.of(context)!.settings.arguments as Sale;

    return Scaffold(
      appBar: AppBar(title: const Text('Receipt')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: sale.items
                  .map((s) => ListTile(
                        title: Text(s.item.name),
                        trailing: Text(
                            '${s.qty} × ${s.item.price.toStringAsFixed(2)}'),
                      ))
                  .toList(),
            ),
          ),
          ListTile(
            title: const Text('Total'),
            trailing: Text(
              'Rs. ${sale.total.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.print)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.picture_as_pdf)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.share)),
            ],
          ),
        ],
      ),
    );
  }
}
