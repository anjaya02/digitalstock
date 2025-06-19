import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../providers/profile_provider.dart';
import '../../providers/sale_provider.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          if (user != null)
            ListTile(
              leading: const Icon(Icons.account_circle, size: 40),
              title: Text(
                profile.displayName?.isNotEmpty == true
                    ? profile.displayName!
                    : (user.email ?? ''),
              ),
              subtitle: const Text('Signed in'),
            ),
          const Divider(height: 0),

          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Manual Sync'),
            onTap: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Sync started…'))),
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Bluetooth Printer'),
            onTap: () => showDialog(
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
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About DigitalStock'),
            onTap: () => _showAbout(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () async {
              await Supabase.instance.client.auth.signOut();
              context.read<SaleProvider>().clearCache();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) => showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('DigitalStock'),
      content: const Text(
        'DigitalStock is a modern, lightweight point-of-sale app designed '
        'for small Sri Lankan shops. It lets you log sales, track stock, '
        'accept cash or LankaQR payments, and generate reports — even '
        'offline.',
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
