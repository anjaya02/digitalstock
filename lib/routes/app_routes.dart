import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/items/item_list_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String items = '/items';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    items: (context) => const ItemListScreen(),
  };
}
