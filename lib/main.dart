import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from root .env file
  // await dotenv.load(fileName: ".env");
  await dotenv.load(fileName: 'assets/config/.env');
// print('dotenv URL  → ${dotenv.env['SUPABASE_URL']}');
// print('dotenv KEY  → ${dotenv.env['SUPABASE_ANON_KEY']?.substring(0,6)}...'); // first 6 chars


  // Initialize Supabase with values from .env
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // print("SUPABASE_URL = ${dotenv.env['SUPABASE_URL']}");

  runApp(const DigitalStockApp());
}
