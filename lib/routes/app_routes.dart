import 'package:flutter/material.dart';

import '../screens/items/item_list_screen.dart';
import '../screens/sales/realtime_sale_screen.dart';
import '../screens/sales/end_of_day_screen.dart';
import '../screens/payment/payment_summary_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static const String items = '/items';
  static const String realtimeSale = '/sale';
  static const String endOfDay = '/end-of-day';
  static const String payment = '/payment-summary';
  static const String settings = '/settings';

  static final Map<String, WidgetBuilder> routes = {
    items: (_) => const ItemListScreen(),
    realtimeSale: (_) => const RealTimeSaleScreen(),
    endOfDay: (_) => const EndOfDayScreen(),
    payment: (_) => const PaymentSummaryScreen(),
    settings: (_) => const SettingsScreen(),
  };
}
