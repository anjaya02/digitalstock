import 'package:flutter/material.dart';
import 'package:pos/screens/settings/settings_screen.dart';

import '../screens/home/home_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/sales/sales_hub_screen.dart';

/// Root scaffold with a persistent bottom NavigationBar.
/// Index 0 = Home, 1 = Sales (stub), 2 = Reports, 3 = Settings
class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_index) {
      case 0:
        body = const HomeScreen();
        break;
      case 1:
        body = const SalesHubScreen();
        break;
      case 2:
        body = const ReportsScreen();
        break;
      case 3:
        body = const SettingsScreen();
        break;
      default:
        body = const Center(child: Text('Sales screen coming soon'));
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.receipt), label: 'Sales'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Reports'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
