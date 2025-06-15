import 'package:flutter/foundation.dart';

class SaleProvider with ChangeNotifier {
  double _totalSales = 0;

  double get totalSales => _totalSales;

  void addSale(double amount) {
    _totalSales += amount;
    notifyListeners();
  }

  void resetSales() {
    _totalSales = 0;
    notifyListeners();
  }
}
