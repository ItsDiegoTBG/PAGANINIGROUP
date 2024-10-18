import 'package:flutter/material.dart';

class SaldoProvider with ChangeNotifier {
  double _saldo = 0.0;

  double get saldo => _saldo;

  void agregar() {
    _saldo = _saldo + 10;
    notifyListeners();
  }
}
