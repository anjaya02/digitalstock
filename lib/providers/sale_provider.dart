import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart'; 

import '../models/sale.dart';
import '../models/payment_method.dart';
import '../models/item.dart';
import 'item_provider.dart';

class SaleProvider with ChangeNotifier {
  SaleProvider(this._itemProvider);

  final ItemProvider _itemProvider;
  final _supabase = Supabase.instance.client;

  final List<Sale> _sales = [];
  List<Sale> get sales => [..._sales];

  // ─────────────────── aggregates ───────────────────
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  double get todayTotal => _sales
      .where((s) => _isSameDay(s.timestamp, DateTime.now()))
      .fold(0.0, (sum, s) => sum + s.total);

  Map<PaymentMethod, double> get todayByMethod => {
    for (var m in PaymentMethod.values)
      m: _sales
          .where(
            (s) => _isSameDay(s.timestamp, DateTime.now()) && s.method == m,
          )
          .fold(0.0, (sum, s) => sum + s.total),
  };

  // ─────────────────── mutations ────────────────────
  Future<void> addSale(Sale sale) async {
    // optimistic local insert
    _sales.add(sale);
    for (final li in sale.items) {
      final newStock = li.item.stock - li.qty;
      _itemProvider.updateStock(li.item.id, newStock);
    }
    notifyListeners();

    // write to Supabase using our own UUID
    final saleId = const Uuid().v4();
    try {
      await _supabase.from('sales').insert({
        'id': saleId,
        'user_id': _supabase.auth.currentUser!.id,
        'timestamp': sale.timestamp.toIso8601String(),
        'payment_method': sale.method.name,
        'total': sale.total,
      });

      await _supabase
          .from('sale_items')
          .insert(
            sale.items
                .map(
                  (li) => {
                    'sale_id': saleId,
                    'item_id': li.item.id,
                    'item_name': li.item.name,
                    'qty': li.qty,
                    'price_each': li.item.price,
                  },
                )
                .toList(),
          );
    } catch (e) {
      debugPrint('Supabase insert failed: $e');
    }
  }

  // ─────────────────── syncing ────────────────────
  Future<void> fetchRemote() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    final rows = await _supabase
        .from('sales')
        .select(
          'id, timestamp, payment_method, total, '
          'sale_items(item_id, item_name, qty, price_each)', 
        )
        .eq('user_id', uid);

    _sales
      ..clear()
      ..addAll(rows.map(_rowToSale));

    notifyListeners();
  }

  Sale _rowToSale(Map<String, dynamic> row) {
    final items = (row['sale_items'] as List<dynamic>).map((i) {
      final item = Item(
        id: i['item_id'],
        name: i['item_name'],
        price: (i['price_each'] as num).toDouble(),
      );
      return SaleItem(item: item, qty: i['qty'] as int);
    }).toList();

    return Sale(
      method: PaymentMethod.values.firstWhere(
        (m) => m.name == row['payment_method'],
      ),
      items: items,
      timestamp: DateTime.parse(row['timestamp']),
    );
  }

  // wipe local cache on logout
  void clearCache() {
    _sales.clear();
    notifyListeners();
  }
}
