import 'package:flutter/foundation.dart';

class SettingsProvider with ChangeNotifier {
  String _language = 'en';

  String get language => _language;

  void switchLanguage(String langCode) {
    _language = langCode;
    notifyListeners();
  }
}
