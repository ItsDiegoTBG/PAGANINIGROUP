import 'package:flutter/material.dart';
import 'package:paganini/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = AppTheme().themeLightMode();
  ThemeData get themeData => _themeData;

  set themeMode(ThemeData value) {
    _themeData = value;
    notifyListeners();
  }
  bool get isDarkMode => _themeData == AppTheme().themeDarkMode();

  void toggleTheme() {
   if(_themeData == AppTheme().themeLightMode()) {
     _themeData = AppTheme().themeDarkMode();
   } else {
     _themeData = AppTheme().themeLightMode();
   }
   notifyListeners();
  }
}