import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/design_system.dart';
import 'routes/app_routes.dart';
import 'providers/item_provider.dart';
import 'providers/sale_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/reports_provider.dart';

class DigitalStockApp extends StatelessWidget {
  const DigitalStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => SaleProvider()),

        // ── Fix: use context.read<T>() and return a new instance in update ──
        ChangeNotifierProxyProvider<SaleProvider, ReportsProvider>(
          create: (context) =>
              ReportsProvider(context.read<SaleProvider>()),
          update: (context, saleProv, _) =>
              ReportsProvider(saleProv),
        ),

        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'DigitalStock',
        debugShowCheckedModeBanner: false,
        theme: DS.theme(),
        initialRoute: AppRoutes.home,
        routes: AppRoutes.routes,
      ),
    );
  }
}
