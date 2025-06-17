import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/main_tabs.dart';
import '../../providers/profile_provider.dart';
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
  final _phoneCtrl = TextEditingController();
  final _otpCtrl   = TextEditingController();

  bool  _usePhone    = false;
  bool  _awaitingOtp = false;
  String? _error;

  final _supabase = Supabase.instance.client;

  // ───────────────────────────────────────────────────
  void _toggleMode() {
    setState(() {
      _usePhone    = !_usePhone;
      _error       = null;
      _awaitingOtp = false;
    });
  }

  Future<void> _handleLogin() async {
    setState(() => _error = null);

    try {
      if (_usePhone) {
        final phone = _phoneCtrl.text.trim();
        await _supabase.auth.signInWithOtp(phone: phone);
        setState(() => _awaitingOtp = true);
      } else {
        final email    = _emailCtrl.text.trim();
        final password = _passCtrl.text;
        await _supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        _goToMainIfLoggedIn();
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _verifyOtp() async {
    try {
      await _supabase.auth.verifyOTP(
        phone: _phoneCtrl.text.trim(),
        token: _otpCtrl.text.trim(),
        type: OtpType.sms,
      );
      _goToMainIfLoggedIn();
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  void _goToMainIfLoggedIn() {
    if (_supabase.auth.currentSession != null) {
      // fetch display-name into provider
      context.read<ProfileProvider>().loadProfile();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainTabs()),
      );
    }
  }

  // ───────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_usePhone ? 'Login via Phone' : 'Login via Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_usePhone) ...[
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number (+9477xxxxxxx)',
                ),
              ),
              if (_awaitingOtp)
                TextField(
                  controller: _otpCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'OTP'),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _awaitingOtp ? _verifyOtp : _handleLogin,
                child: Text(_awaitingOtp ? 'Verify OTP' : 'Send OTP'),
              ),
            ] else ...[
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleLogin,
                child: const Text('Login'),
              ),
            ],

            const SizedBox(height: 16),

            // ── Forgot password ────────────────────────────────
            if (!_usePhone)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResetPasswordScreen(),
                    ),
                  ),
                  child: const Text('Forgot password?'),
                ),
              ),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            // ── Switch mode / Sign-up link ─────────────────────
            TextButton(
              onPressed: _toggleMode,
              child: Text(_usePhone ? 'Use Email Instead' : 'Use Phone Instead'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                );
              },
              child: const Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
