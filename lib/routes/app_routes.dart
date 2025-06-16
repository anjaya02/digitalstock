import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/items/item_list_screen.dart';
import '../screens/sale/realtime_sale_screen.dart';
import '../screens/sale/end_of_day_screen.dart';
import '../screens/payment/payment_summary_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  // names
  static const String home         = '/';
  static const String items        = '/items';
  static const String realtimeSale = '/sale';
  static const String endOfDay     = '/end-of-day';
  static const String payment      = '/payment-summary';
  static const String reports      = '/reports';
  static const String settings     = '/settings';

  // map
  static final Map<String, WidgetBuilder> routes = {
    home:         (_) => const HomeScreen(),
    items:        (_) => const ItemListScreen(),
    realtimeSale: (_) => const RealTimeSaleScreen(),
    endOfDay:     (_) => const EndOfDayScreen(),
    payment:      (_) => const PaymentSummaryScreen(),
    reports:      (_) => const ReportsScreen(),
    settings:     (_) => const SettingsScreen(),
  };
}
