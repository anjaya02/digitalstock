import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://YOUR-PROJECT.supabase.co',
    anonKey: 'public-anon-key',
  );
  runApp(const DigitalStockApp());
}