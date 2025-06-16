import 'package:flutter/foundation.dart';
import '../models/item.dart';

class ItemProvider with ChangeNotifier {
  final List<Item> _items = [
    Item(id: '1', name: 'Bun', price: 30.0, stock: 50),
    Item(id: '2', name: 'Milk Packet', price: 100.0, stock: 20),
    Item(id: '3', name: 'Notebook', price: 150.0, stock: 10),
  ];

  List<Item> get items => [..._items];

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void updateStock(String id, int newStock) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].stock = newStock;
      notifyListeners();
    }
  }
}
