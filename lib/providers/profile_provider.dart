import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileProvider with ChangeNotifier {
  String? _displayName;
  String? get displayName => _displayName;

  final _supabase = Supabase.instance.client;

  /// Loads the current user’s profile.
  /// If the record doesn’t exist yet (first login), create a blank row.
  Future<void> loadProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final data = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();                 // ← safe when 0 rows

    if (data == null) {
      // first time this user logs in – create an empty profile row
      await _supabase.from('profiles').insert({'id': userId});
      _displayName = '';
    } else {
      _displayName = (data['display_name'] as String?) ?? '';
    }
    notifyListeners();
  }

  /// Updates the display name (creates or upserts row if needed).
  Future<void> updateDisplayName(String newName) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('profiles').upsert({
      'id'           : userId,
      'display_name' : newName,
    });

    _displayName = newName;
    notifyListeners();
  }
}
