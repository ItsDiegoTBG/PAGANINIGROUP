import 'package:flutter/material.dart';
import 'package:paganini/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  static const _themeKey = 'isDarkMode'; 
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  /// Cargar el tema almacenado en Hive.
  Future<void> _loadThemePreference() async {
    final box = await Hive.openBox('settingsBox'); // Asegúrate de que la caja esté abierta.
    _isDarkMode = box.get(_themeKey, defaultValue: false); // Falso por defecto.
    notifyListeners();
  }

  /// Alternar entre temas oscuros y claros.
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final box = Hive.box('settingsBox'); // Obtén la caja previamente abierta.
    await box.put(_themeKey, _isDarkMode); // Guarda el estado del tema.
    notifyListeners(); 
  }
}
