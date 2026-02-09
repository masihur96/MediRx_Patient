import 'package:flutter/material.dart';

enum AppLanguage { en, bn }

class LocalizationProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.en;

  AppLanguage get language => _language;

  void setLanguage(AppLanguage lang) {
    if (_language != lang) {
      _language = lang;
      notifyListeners();
    }
  }

  static final Map<AppLanguage, Map<String, String>> _localizedValues = {
    AppLanguage.en: {
      'app_name': 'MediRx',
      'welcome': 'Welcome to MediRx',
      'tagline': 'Your personal health companion',
      'get_started': 'GET STARTED',
      'home': 'Home',
      'medication': 'Medication',
      'scheduling': 'Scheduling',
      'ai_doctor': 'AI Doctor',
      'vaccine': 'Vaccine',
      'nearest_medical': 'Nearest Medical',
      'pediatric_dose': 'Pediatric Dose',
      'doctor_rating': 'Doctor Rating',
      'pregnancy': 'Pregnancy Tracking',
      'menstrual_cycle': 'Menstrual Cycle',
      'settings': 'Settings',
      'profile': 'Profile',
      'language': 'Language',
      'english': 'English',
      'bangla': 'Bangla',
    },
    AppLanguage.bn: {
      'app_name': 'মেডি-আরএক্স',
      'welcome': 'মেডি-আরএক্স-এ স্বাগতম',
      'tagline': 'আপনার ব্যক্তিগত স্বাস্থ্য সঙ্গী',
      'get_started': 'শুরু করুন',
      'home': 'হোম',
      'medication': 'ওষুধ ব্যবস্থাপনা',
      'scheduling': 'সময়সূচী',
      'ai_doctor': 'এআই ডাক্তার',
      'vaccine': 'টিকা',
      'nearest_medical': 'নিকটস্থ চিকিৎসা',
      'pediatric_dose': 'শিশুর ডোজ',
      'doctor_rating': 'ডাক্তার রেটিং',
      'pregnancy': 'গর্ভাবস্থা ট্র্যাকিং',
      'menstrual_cycle': 'মাসিক চক্র',
      'settings': 'সেটিংস',
      'profile': 'প্রোফাইল',
      'language': 'ভাষা',
      'english': 'ইংরেজি',
      'bangla': 'বাংলা',
    },
  };

  String translate(String key) {
    return _localizedValues[_language]?[key] ?? key;
  }
}
