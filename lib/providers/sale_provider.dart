import 'package:flutter/foundation.dart';

import '../models/sale.dart';
import '../models/payment_method.dart';
import 'item_provider.dart';

class SaleProvider with ChangeNotifier {
  SaleProvider(this._itemProvider);

  final ItemProvider _itemProvider;
  final List<Sale> _sales = [];

  List<Sale> get sales => [..._sales];

  // ───────── helpers ─────────
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ───────── aggregates ───────
  double get todayTotal => _sales
      .where((s) => _isSameDay(s.timestamp, DateTime.now()))
      .fold(0.0, (sum, s) => sum + s.total);

  Map<PaymentMethod, double> get todayByMethod => {
        for (var m in PaymentMethod.values)
          m: _sales
              .where((s) =>
                  _isSameDay(s.timestamp, DateTime.now()) && s.method == m)
              .fold(0.0, (sum, s) => sum + s.total)
      };

  // ───────── mutations ────────
  void addSale(Sale sale) {
    _sales.add(sale);

    // ➊ decrement stock for every line item
    for (final sItem in sale.items) {
      final newStock = sItem.item.stock - sItem.qty;
      _itemProvider.updateStock(sItem.item.id, newStock);
    }

    notifyListeners();
  }

  void resetDay() {
    _sales.clear();
    notifyListeners();
  }
}
