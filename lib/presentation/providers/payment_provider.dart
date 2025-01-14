import 'dart:isolate';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:paganini/domain/entity/user_entity.dart';

class PaymentProvider with ChangeNotifier {
  bool _isSaldoSelected = false;
  double _montoSaldo = 0.0;
  final Map<int, double> _selectedCardAmounts = {};
  double _totalAmountPayUser = 0.0;
  String _nameUserToPay = "";
  bool _isConfirmPaymetOrPaymentSelected = false;
  String _noteUserToPay = "";

  bool _isOnlySaldoSelected = false;
  UserEntity? _userPaymentData;

  bool get isSaldoSelected => _isSaldoSelected;
  bool get isOnlySaldoSelected => _isOnlySaldoSelected;
  double get montoSaldo => _montoSaldo;
  Map<int, double> get selectedCardAmounts => _selectedCardAmounts;
  double get totalAmountPayUser => _totalAmountPayUser;
  String get nameUserToPay => _nameUserToPay;
  bool get isConfirmPaymetOrPaymentSelected =>
      _isConfirmPaymetOrPaymentSelected;
  String get noteUserToPay => _noteUserToPay;
  UserEntity? get userPaymentData => _userPaymentData;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

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
    _userPaymentData = null;
    notifyListeners();
  }

  void clearTotalAmountPayUser() {
    _totalAmountPayUser = 0.0;
    notifyListeners();
  }

  void initializeUserPaymentData(String id) {
    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser != null || id.isNotEmpty) {
        // Usar el id proporcionado como argumento
        final userRef = FirebaseDatabase.instance.ref('users/$id');
        final snapshot = await userRef.get();

        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          _userPaymentData = UserEntity.fromMapEntity(
            id, // Usamos el id recibido como argumento
            data.map((key, value) => MapEntry(key.toString(), value)),
          );
        } else {
          _userPaymentData = null;
        }
      } else {
        _userPaymentData = null;
      }
      notifyListeners();
    });
  }

   Future<void> updateUserPaymentSaldo(UserEntity user, double amount) async {
    debugPrint("El user es: $user");
    debugPrint("El id es: ${user.id}");
    debugPrint("El amount es: $amount");
    debugPrint("El saldo del usuario es: ${user.saldo}");
    try {
      debugPrint("Entro al try de updateUserPaymentSaldo");
      double newSaldo = user.saldo + amount;
      await _database.ref('users').child(user.id).update({'saldo': newSaldo});
      debugPrint("Saldo actualizado exitosamente para el usuario receptor");
    } catch (e) {
      debugPrint('Error al actualizar el saldo del usuario: $e');
    }
  }
}
