import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('fr'));

  static const Map<String, String> languageCodeMap = {
    "Français": "fr",
    "English": "en",
    "العربية": "ar",
  };

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String lang = prefs.getString("langue") ?? "Français";
    final String code = languageCodeMap[lang] ?? "fr";
    localeNotifier.value = Locale(code);
  }

  static Future<void> changeLanguage(String langName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("langue", langName);
    
    final String code = languageCodeMap[langName] ?? "fr";
    localeNotifier.value = Locale(code);
  }
}
