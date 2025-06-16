import 'package:flutter/foundation.dart';
import '../models/sale.dart';
import '../models/payment_method.dart';

class SaleProvider with ChangeNotifier {
  final List<Sale> _sales = [];

  List<Sale> get sales => [..._sales];

  // ── Aggregates ────────────────────────────────────────────────────────────
  double get todayTotal => _sales
      .where((s) =>
          DateTime.now().difference(s.timestamp).inDays == 0)
      .fold(0.0, (sum, s) => sum + s.total);

  Map<PaymentMethod, double> get todayByMethod {
    return {
      for (var m in PaymentMethod.values)
        m: _sales
            .where((s) =>
                DateTime.now().difference(s.timestamp).inDays == 0 &&
                s.method == m)
            .fold(0.0, (sum, s) => sum + s.total)
    };
  }

  // ── Mutations ─────────────────────────────────────────────────────────────
  void addSale(Sale sale) {
    _sales.add(sale);
    notifyListeners();
  }

  void resetDay() {
    _sales.clear();
    notifyListeners();
  }
}
