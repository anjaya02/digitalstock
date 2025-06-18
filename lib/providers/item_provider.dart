import 'package:flutter/foundation.dart';
import '../models/item.dart';

class ItemProvider with ChangeNotifier {
  final List<Item> _items = [
    Item(id: '1', name: 'Bun', price: 60.0, stock: 50),
    Item(id: '2', name: 'Milk Packet', price: 400.0, stock: 20),
    Item(id: '3', name: 'Notebook', price: 150.0, stock: 10),
  ];

  List<Item> get items => [..._items];

  /// Add a new item
  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  /// Update item fields (name, price, stock) by ID
  void updateItem(String id, {String? name, double? price, int? stock}) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final current = _items[index];
    _items[index] = Item(
      id: current.id,
      name: name ?? current.name,
      price: price ?? current.price,
      stock: stock ?? current.stock,
    );
    notifyListeners();
  }

  /// Delete item by ID
  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Only update stock using mutable field
  void updateStock(String id, int newStock) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].stock = newStock;
      notifyListeners();
    }
  }

  /// Get item by ID
  Item? getItemById(String id) {
    return _items.firstWhere(
      (item) => item.id == id,
      orElse: () => Item(id: '', name: '', price: 0, stock: 0),
    );
  }

  /// Optional: Clear all items
  void clearItems() {
    _items.clear();
    notifyListeners();
  }
}
