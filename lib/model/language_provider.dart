import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale? _appLocale;

  Locale? get appLocale => _appLocale;

  LanguageProvider({Locale? initialLocale}) {
    if (initialLocale != null) {
      _appLocale = initialLocale;
      _saveLocale(initialLocale);
    } else {
      loadLocale();
    }
  }

  Future<void> _saveLocale(Locale locale) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  void changeLanguage(Locale type) async {
    if (_appLocale == type) {
      return;
    }
    _appLocale = type;
    await _saveLocale(type);
    notifyListeners();
  }

  void loadLocale() async {
    var prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      _appLocale = Locale(languageCode);
    } else {
      _appLocale = const Locale('ko'); // Default to Korean
    }
    notifyListeners();
  }
}
