
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class IntroductionProvider with ChangeNotifier{
  static const _introductionKey = 'isIntroductionPage';
  bool _isIntroductionPage = true;

  bool get isIntroductionPage => _isIntroductionPage;

  IntroductionProvider(){
    _loadIntroductionPreference();
  }

  Future<void> _loadIntroductionPreference() async {
    final box = await Hive.openBox('settingsBox'); // Asegúrate de que la caja esté abierta.
    _isIntroductionPage = box.get(_introductionKey, defaultValue: true); // Verdadero por defecto.
    notifyListeners();
  }

  Future<void> closeForEverything() async {
    _isIntroductionPage = false;
    final box = Hive.box('settingsBox'); // Obtén la caja previamente abierta.
    await box.put(_introductionKey, false); // Guarda el estado del tema.
    notifyListeners(); 
  }
} 