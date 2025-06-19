import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/main_tabs.dart';
import '../../providers/profile_provider.dart';
import '../../providers/sale_provider.dart';
import 'signup_screen.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  bool   _loading = false;
  String? _error;

  final _supabase = Supabase.instance.client;

  // ───────────────────────── actions ─────────────────────────
  Future<void> _handleLogin() async {
    setState(() { _loading = true; _error = null; });
    try {
      await _supabase.auth.signInWithPassword(
        email   : _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      await _goToMainIfLoggedIn();              
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _resendConfirm() async {
    try {
      await _supabase.auth.resend(
        email: _emailCtrl.text.trim(),
        type : OtpType.signup,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Confirmation link sent')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  /// Navigates to MainTabs and pre-loads the signed-in user’s sales.
  Future<void> _goToMainIfLoggedIn() async {
    if (_supabase.auth.currentSession == null) return;

    // eager-load profile + sales for this user
    await context.read<ProfileProvider>().loadProfile();
    await context.read<SaleProvider>().fetchRemote();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainTabs()),
    );
  }

  // ───────────────────────── UI ─────────────────────────
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom + 24;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _loading ? null : _handleLogin,
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ResetPasswordScreen()),
                  ),
                  child: const Text('Forgot password?'),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red)),
                if (_error!.toLowerCase().contains('not confirmed'))
                  TextButton(
                    onPressed: _resendConfirm,
                    child: const Text('Resend confirmation e-mail'),
                  ),
              ],
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                ),
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
