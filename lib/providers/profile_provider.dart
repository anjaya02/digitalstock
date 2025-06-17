import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileProvider with ChangeNotifier {
  String? _displayName;
  String? get displayName => _displayName;

  final _supabase = Supabase.instance.client;

  Future<void> loadProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final data = await _supabase
        .from('profiles')
        .select() // ← no type argument
        .eq('id', userId)
        .single(); // returns Map<String, dynamic>

    _displayName = (data['display_name'] as String?) ?? '';
    notifyListeners();
  }

  Future<void> updateDisplayName(String newName) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('profiles').upsert({
      'id': userId,
      'display_name': newName,
    });

    _displayName = newName;
    notifyListeners();
  }
}
