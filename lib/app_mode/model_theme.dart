import 'package:flutter/material.dart';
import 'package:projecture/app_mode/my_theme_preferences.dart';

class ModelTheme extends ChangeNotifier {
  late bool _isDark;
  late myThemePreferences _preferences;

  bool get isDark => _isDark;
  ModelTheme() {
    _isDark = false;
    _preferences = myThemePreferences();
    getPreferences();
  }
  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}
