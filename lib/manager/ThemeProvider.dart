import 'package:flutter/material.dart';

enum ThemeModeType { Light, Dark, System }

class ThemeProvider with ChangeNotifier {
  ThemeModeType _themeMode = ThemeModeType.Light;

  ThemeModeType get themeMode => _themeMode;

  void setThemeMode(ThemeModeType mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
