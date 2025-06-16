import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/settings_provider.dart';
// import '../../../ui/design_system.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('සිංහල / English'),
            value: settings.language == 'si',
            onChanged: (_) => settings.switchLanguage(
                settings.language == 'si' ? 'en' : 'si'),
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Manual Sync'),
            onTap: () {
              // TODO
            },
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Bluetooth Printer'),
            onTap: () {
              // TODO
            },
          ),
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: 'DigitalStock',
            applicationVersion: '0.1.0',
            applicationLegalese: '© 2025',
          ),
        ],
      ),
    );
  }
}
