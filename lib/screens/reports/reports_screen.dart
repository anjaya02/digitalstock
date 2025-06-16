import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/reports_provider.dart';
import '../../../ui/design_system.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = context.watch<ReportsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            DS.summaryCard(
                'Daily (Today)',
                'Rs. ${reports.getTotalForPastDays(1).toStringAsFixed(0)}'),
            const SizedBox(height: 16),
            DS.summaryCard(
                'Weekly (Last 7 days)',
                'Rs. ${reports.getTotalForPastDays(7).toStringAsFixed(0)}'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                // TODO: generate PDF or CSV
              },
              icon: const Icon(Icons.download),
              label: const Text('Download Report'),
            )
          ],
        ),
      ),
    );
  }
}
