import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/reports_provider.dart';
import '../../ui/design_system.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rpt = context.watch<ReportsProvider>();

    Widget tile(String title, String subtitle, VoidCallback onTap) {
      return ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: DS.cardGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.calendar_month, size: 24),
        ),
        title: Text(title,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: ListView(
          children: [
            // Daily section
            Text('Daily Reports',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            tile(
              'Today’s Report',
              'Generate a report for today’s sales',
              () {
                // Example: use rpt.getTotalForPastDays(1)
              },
            ),
            const SizedBox(height: 20),
            tile(
              'Yesterday’s Report',
              'Generate a report for yesterday’s sales',
              () {},
            ),
            const SizedBox(height: 32),

            // Weekly section
            Text('Weekly Reports',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            tile(
              'This Week’s Report',
              'Generate a report for this week’s sales',
              () {},
            ),
            const SizedBox(height: 20),
            tile(
              'Last Week’s Report',
              'Generate a report for last week’s sales',
              () {},
            ),
          ],
        ),
      ),
    );
  }
}
