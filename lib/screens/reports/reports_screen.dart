import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../models/sale.dart';
import '../../providers/sale_provider.dart';
import '../../ui/design_system.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  // ─────────────────── data helpers ───────────────────
  Iterable<Sale> _inRange(List<Sale> sales, DateTime from, DateTime to) =>
      sales.where((s) =>
          !s.timestamp.isBefore(from) && !s.timestamp.isAfter(to));

  /// item-name → {qty, amount}
  Map<String, _ItemSummary> _summariseItems(
      Iterable<Sale> rangeSales) {
    final map = <String, _ItemSummary>{};
    for (final sale in rangeSales) {
      for (final si in sale.items) {
        map.update(
          si.item.name,
          (prev) => prev..add(si.qty, si.item.price),
          ifAbsent: () {
            final summary = _ItemSummary();
            summary.add(si.qty, si.item.price);
            return summary;
          },
        );
      }
    }
    return map;
  }

  // ─────────────────── PDF builders ───────────────────
  Future<void> _exportRangePdf(
    BuildContext ctx, {
    required String title,
    required DateTime from,
    required DateTime to,
  }) async {
    final saleProv = ctx.read<SaleProvider>();
    final rangeSales = _inRange(saleProv.sales, from, to);
    final items = _summariseItems(rangeSales);

    final total = items.values.fold<double>(0, (sum, e) => sum + e.amount);

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('DigitalStock – $title',
                style: pw.TextStyle(
                    fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text(
                'Period: ${from.toLocal().toIso8601String().substring(0, 10)}'
                '  →  ${to.toLocal().toIso8601String().substring(0, 10)}'),
            pw.SizedBox(height: 16),
            if (items.isEmpty)
              pw.Text('No sales in this period.')
            else
              pw.Table.fromTextArray(
                headers: ['Item', 'Qty', 'Amount (Rs.)'],
                data: items.entries
                    .map((e) => [
                          e.key,
                          e.value.qty.toString(),
                          e.value.amount.toStringAsFixed(0)
                        ])
                    .toList(),
                headerStyle:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
                cellStyle: const pw.TextStyle(fontSize: 11),
                border: null,
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            pw.SizedBox(height: 12),
            pw.Divider(),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('TOTAL  Rs. ${total.toStringAsFixed(0)}',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 14)),
            )
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) => doc.save(),
      name: title.replaceAll(' ', '_').toLowerCase() + '.pdf',
    );
  }

  // Quick combined summary like before
  Future<void> _exportQuickSummary(BuildContext ctx) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    await _exportRangePdf(ctx,
        title: 'Quick Summary (Today)',
        from: todayStart,
        to: now); // simple wrap
  }

  // convenience constructor for the clickable ListTiles
  Widget _tile(
    BuildContext ctx, {
    required String label,
    required DateTime from,
    required DateTime to,
  }) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: DS.cardGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.picture_as_pdf, size: 24),
      ),
      title: Text(label,
          style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      onTap: () => _exportRangePdf(ctx,
          title: label, from: from, to: to),
      contentPadding: EdgeInsets.zero,
    );
  }

  // ────────────────────── UI ────────────────────────
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    final thisWeekStart =
        todayStart.subtract(Duration(days: now.weekday - 1));
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: ListView(
          children: [
            Text('Daily Reports',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _tile(
              context,
              label: 'Today’s Report',
              from: todayStart,
              to: now,
            ),
            const SizedBox(height: 20),
            _tile(
              context,
              label: 'Yesterday’s Report',
              from: yesterdayStart,
              to: todayStart.subtract(const Duration(seconds: 1)),
            ),
            const SizedBox(height: 32),
            Text('Weekly Reports',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _tile(
              context,
              label: 'This Week’s Report',
              from: thisWeekStart,
              to: now,
            ),
            const SizedBox(height: 20),
            _tile(
              context,
              label: 'Last Week’s Report',
              from: lastWeekStart,
              to: thisWeekStart.subtract(const Duration(seconds: 1)),
            ),
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: () => _exportQuickSummary(context),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export Today as PDF'),
            ),
          ],
        ),
      ),
    );
  }
}

// simple container for qty & amount
class _ItemSummary {
  int qty = 0;
  double amount = 0;

  void add(int q, double price) {
    qty += q;
    amount += q * price;
  }
}
