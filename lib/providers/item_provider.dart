import 'package:flutter/material.dart';

class ItemProvider with ChangeNotifier {
  // Dummy example for now
final List<String> _items = [];

  List<String> get items => _items;

  void addItem(String name) {
    _items.add(name);
    notifyListeners();
  }
}
