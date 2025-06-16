import 'package:flutter/foundation.dart';
import 'sale_provider.dart';

class ReportsProvider with ChangeNotifier {
  ReportsProvider(this.saleProvider);

  final SaleProvider saleProvider;

  double getTotalForPastDays(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days - 1));
    return saleProvider.sales
        .where((s) => s.timestamp.isAfter(cutoff))
        .fold(0.0, (sum, s) => sum + s.total);
  }
}
