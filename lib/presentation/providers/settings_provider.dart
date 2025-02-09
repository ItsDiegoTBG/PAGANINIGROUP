import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final Map<String, bool> _switchStates = {};

  SettingsProvider() {
    _loadPreferences();
  }

  bool getSwitchState(String key) => _switchStates[key] ?? false;

  void setSwitchState(String key, bool value) async {
    _switchStates[key] = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    for (String key in prefs.getKeys()) {
      _switchStates[key] = prefs.getBool(key) ?? false;
    }
    notifyListeners();
  }
}
