
import 'package:hive/hive.dart';

void saveThemePreference(bool isDarkMode) async {
  var box = Hive.box('settingsThemeBox');
  box.put('isDarkMode', isDarkMode); // Guarda la preferencia.
}

bool getThemePreference() {
  var box = Hive.box('settingsThemeBox');
  return box.get('isDarkMode', defaultValue: false); // Recupera la preferencia.
}