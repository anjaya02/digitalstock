import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/design_system.dart';
import 'routes/app_routes.dart';
import 'widgets/main_tabs.dart';

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
        ChangeNotifierProxyProvider<SaleProvider, ReportsProvider>(
          create: (context) => ReportsProvider(context.read<SaleProvider>()),
          update: (context, saleProv, _) => ReportsProvider(saleProv),
        ),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'DigitalStock',
        debugShowCheckedModeBanner: false,
        theme: DS.theme(),

        // ───── ONLY THIS route map; NO `home:` property ─────
        initialRoute: '/',
        routes: {
          '/': (_) => const MainTabs(), // root → the tab scaffold
          ...AppRoutes.routes, // every other page
        },
      ),
    );
  }
}
