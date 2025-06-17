import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // ── Language toggle ──────────────────────────────────────────────
          SwitchListTile(
            title: const Text('සිංහල / English'),
            value: settings.language == 'si',
            onChanged: (_) {
              final next = settings.language == 'si' ? 'en' : 'si';
              context.read<SettingsProvider>().switchLanguage(next);
            },
          ),

          // ── Manual Sync ─────────────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Manual Sync'),
            onTap: () {
              // TODO: start sync logic here
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Sync started…')));
            },
          ),

          // ── Bluetooth Printer ───────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Bluetooth Printer'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Coming soon'),
                  content: const Text(
                    'Bluetooth printer integration is not available in this '
                    'version of DigitalStock.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),

          // ── About DigitalStock ──────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About DigitalStock'),
            onTap: () => _showAbout(context),
          ),
        ],
      ),
    );
  }

  // ── About Dialog ───────────────────────────────────────────────────────
  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('DigitalStock v0.1.0'),
        content: const Text(
          'DigitalStock is a modern, lightweight point-of-sale app designed '
          'for small Sri Lankan shops. It lets you log sales, track stock, '
          'accept cash or LankaQR payments, and generate daily or weekly '
          'reports — all optimised for low-bandwidth and offline use.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
