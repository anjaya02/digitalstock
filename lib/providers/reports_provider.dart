import 'package:flutter/foundation.dart';
import 'sale_provider.dart';

class ReportsProvider with ChangeNotifier {
  ReportsProvider(this._saleProvider) {
    _saleProvider.addListener(_forward);
  }

  SaleProvider _saleProvider;

  /// Called by ChangeNotifierProxyProvider when the SaleProvider instance changes
  void updateSaleProvider(SaleProvider newProv) {
    if (identical(newProv, _saleProvider)) return;
    _saleProvider.removeListener(_forward);
    _saleProvider = newProv;
    _saleProvider.addListener(_forward);
    notifyListeners();
  }

  // Relay SaleProvider changes
  void _forward() => notifyListeners();

  /// Inclusive total for the past `days` (e.g. days == 1 → today only).
  double getTotalForPastDays(int days) {
    final now    = DateTime.now();
    final cutoff = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: days - 1));

    return _saleProvider.sales
        .where((s) => !s.timestamp.isBefore(cutoff))
        .fold(0.0, (sum, s) => sum + s.total);
  }
}
