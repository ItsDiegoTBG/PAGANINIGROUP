import 'dart:isolate';

import 'package:flutter/material.dart';

class PaymentProvider with ChangeNotifier {
  bool _isSaldoSelected = false;
  double _montoSaldo = 0.0;
  final Map<int, double> _selectedCardAmounts = {};
  double _totalAmountPayUser = 0.0;
  String _nameUserToPay = "";
  bool _isConfirmPaymetOrPaymentSelected = false;
  String _noteUserToPay = "";

   bool _isOnlySaldoSelected = false;

  bool get isSaldoSelected => _isSaldoSelected;
  bool get isOnlySaldoSelected =>  _isOnlySaldoSelected;
  double get montoSaldo => _montoSaldo;
  Map<int, double> get selectedCardAmounts => _selectedCardAmounts;
  double get totalAmountPayUser => _totalAmountPayUser;
  String get nameUserToPay => _nameUserToPay;
  bool get isConfirmPaymetOrPaymentSelected => _isConfirmPaymetOrPaymentSelected;
  String get noteUserToPay => _noteUserToPay;

  void setNoteUserToPay(String value) {
    _noteUserToPay = value;
    notifyListeners();
  }

  void setOnlySaldoSelected() {
    _isOnlySaldoSelected = true;
    notifyListeners();
  }

  void toggleSaldoSelection() {
    _isSaldoSelected = !_isSaldoSelected;
    notifyListeners();
  }

  void toggleConfirmPaymetOrPaymentSelected() {
    _isConfirmPaymetOrPaymentSelected = !_isConfirmPaymetOrPaymentSelected;
    notifyListeners();
  }

  void setNameUserToPay(String value) {
    _nameUserToPay = value;
    notifyListeners();
  }

  void setTotalAmountPayUser(double value) {
    _totalAmountPayUser = value;
    notifyListeners();
  }

  void setMontoSaldo(double value) {
    _montoSaldo = value;
    notifyListeners();
  }

  void setCardAmount(int cardId, double amount) {
    _selectedCardAmounts[cardId] = amount;
    notifyListeners();
  }

  void clearSelection() {
    _isConfirmPaymetOrPaymentSelected = false;
   // _totalAmountPayUser = 0.0;
    _noteUserToPay = "";
    _selectedCardAmounts.clear();
    _montoSaldo = 0.0;
    _isSaldoSelected = false;
    notifyListeners();
  }

  void clearTotalAmountPayUser() {
    _totalAmountPayUser = 0.0;
    notifyListeners();
  }
}
