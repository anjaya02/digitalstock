import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/auth/login_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'widgets/main_tabs.dart';

class StartupGate extends StatelessWidget {
  const StartupGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _decideStartPage(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snap.data as Widget;
      },
    );
  }

  Future<Widget> _decideStartPage() async {
    final prefs = await SharedPreferences.getInstance();
    final seenIntro = prefs.getBool('onboarding_done') ?? false;

    // 1. first app launch → onboarding
    if (!seenIntro) return const OnboardingScreen();

    // 2. already logged in?
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) return const MainTabs();

    // 3. otherwise show Login / Sign-up
    return const LoginScreen();
  }
}
