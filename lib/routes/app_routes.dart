import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
// Import other screens when they are created
// import '../screens/reports/reports_screen.dart';
// import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String reports = '/reports';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    // reports: (context) => const ReportsScreen(),
    // settings: (context) => const SettingsScreen(),
  };
}
