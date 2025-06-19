import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/design_system.dart';
import 'routes/app_routes.dart';
import 'startup_gate.dart';

import 'providers/item_provider.dart';
import 'providers/sale_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/reports_provider.dart';
import 'providers/profile_provider.dart';
import 'widgets/auth_state_listener.dart';

class DigitalStockApp extends StatelessWidget {
  const DigitalStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),

        ChangeNotifierProxyProvider<ItemProvider, SaleProvider>(
          create: (context) =>
              SaleProvider(Provider.of<ItemProvider>(context, listen: false)),
          update: (context, itemProv, prev) => prev ?? SaleProvider(itemProv),
        ),

        ChangeNotifierProxyProvider<SaleProvider, ReportsProvider>(
          create: (context) => ReportsProvider(
            Provider.of<SaleProvider>(context, listen: false),
          ),
          update: (context, saleProv, _) => ReportsProvider(saleProv),
        ),

        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()), // ✅ profile
      ],
      child: AuthStateListener(
        child: MaterialApp(
          title: 'DigitalStock',
          debugShowCheckedModeBanner: false,
          theme: DS.theme(),

          home: const StartupGate(),

          routes: {
            ...AppRoutes.routes,
           
          },
        ),
      ),
    );
  }
}
