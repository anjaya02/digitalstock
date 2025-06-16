import 'package:pos/models/item.dart';
import 'payment_method.dart';

class SaleItem {
  final Item item;
  int qty;

  SaleItem({required this.item, this.qty = 1});

  double get lineTotal => item.price * qty;
}

class Sale {
  final DateTime timestamp;
  final PaymentMethod method;
  final List<SaleItem> items;

  Sale({
    required this.method,
    required this.items,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  double get total =>
      items.fold(0, (sum, sItem) => sum + sItem.lineTotal);
}
