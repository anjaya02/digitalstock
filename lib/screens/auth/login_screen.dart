import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/main_tabs.dart';
import '../../ui/design_system.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _oauth(BuildContext ctx, Provider provider) async {
    final supa = Supabase.instance.client;
    try {
      await supa.auth.signInWithOAuth(
        provider,
        redirectTo: 'io.supabase.digitalstock://login-callback', // Android
      );
      if (supa.auth.currentSession != null && ctx.mounted) {
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (_) => const MainTabs()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        ctx,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DS.bgWhite,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DigitalStock',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 60),
            FilledButton.icon(
              onPressed: () => _oauth(context, Provider.google),
              icon: const Icon(Icons.g_mobiledata),
              label: const Text('Sign in with Google'),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _oauth(context, Provider.facebook),
              icon: const Icon(Icons.facebook),
              style: FilledButton.styleFrom(backgroundColor: Colors.blue),
              label: const Text('Sign in with Facebook'),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () {
                Supabase.instance.client.auth.signOut();
              },
              child: const Text('Sign out (debug)'),
            ),
          ],
        ),
      ),
    );
  }
}
