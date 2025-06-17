import 'package:flutter/foundation.dart';
import 'sale_provider.dart';

class ReportsProvider with ChangeNotifier {
  ReportsProvider(this.saleProvider);

  final SaleProvider saleProvider;

  /// Inclusive total for the past `days` (e.g. days == 1 → today only).
  double getTotalForPastDays(int days) {
    final now = DateTime.now();
    final cutoff = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: days - 1));

    return saleProvider.sales
        .where((s) => !s.timestamp.isBefore(cutoff))
        .fold(0.0, (sum, s) => sum + s.total);
  }
}
