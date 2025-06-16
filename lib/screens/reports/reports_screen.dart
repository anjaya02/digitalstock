import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../providers/reports_provider.dart';
import '../../ui/design_system.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rpt = context.watch<ReportsProvider>();

    Future<void> _exportPdf() async {
      final doc = pw.Document();

      doc.addPage(
        pw.Page(
          build: (pw.Context ctx) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'DigitalStock – Sales Report',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Today:  Rs. ${rpt.getTotalForPastDays(1).toStringAsFixed(0)}',
                ),
                pw.Text(
                  'Yesterday:  Rs. ${rpt.getTotalForPastDays(2).toStringAsFixed(0)}',
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'This Week:  Rs. ${rpt.getTotalForPastDays(7).toStringAsFixed(0)}',
                ),
                pw.Text(
                  'Last Week:  Rs. ${rpt.getTotalForPastDays(14).toStringAsFixed(0)}',
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (format) => doc.save(),
        name: 'digitalstock_report.pdf',
      );
    }

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
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: ListView(
          children: [
            Text(
              'Daily Reports',
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            tile('Today’s Report', 'Generate a report for today’s sales', () {
              // could show preview dialog here
            }),
            const SizedBox(height: 20),
            tile(
              'Yesterday’s Report',
              'Generate a report for yesterday’s sales',
              () {},
            ),
            const SizedBox(height: 32),
            Text(
              'Weekly Reports',
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w700),
            ),
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
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: _exportPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export as PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
