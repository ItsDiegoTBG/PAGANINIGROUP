import 'package:flutter/material.dart';

class SaldoProvider with ChangeNotifier {
  double _saldo = 0.0;
 
  double get saldo => _saldo;


  void agregar() {
    _saldo = _saldo + 1000;
    notifyListeners();
  }

  void setZero() {
    _saldo = 0.0;
    notifyListeners();
  }
  void addRecharge(double recharge) {
    _saldo = _saldo + recharge;
    notifyListeners();
  }

  void subRecharge(double value) {
    _saldo = _saldo - value;
    notifyListeners();
  }
}
