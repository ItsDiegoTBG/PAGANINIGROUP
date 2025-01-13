import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:paganini/presentation/providers/user_provider.dart';

class SaldoProvider with ChangeNotifier {

  DatabaseReference? _saldoRef;
  double _saldo = 0.0;

  double get saldo => _saldo;

  SaldoProvider(String userId) {
    _initializeSaldo(userId); // Método para inicializar saldoRef y escuchar cambios
  }

  void _initializeSaldo(String userId) {
    // Inicializa la referencia del saldo para el usuario específico
    _saldoRef = FirebaseDatabase.instance.ref().child('users/$userId/saldo');
    
    // Escucha cambios en tiempo real
    _saldoRef?.onValue.listen((event) {
      final newSaldo = event.snapshot.value as double?;
      if (newSaldo != null) {
        _saldo = newSaldo;
        notifyListeners();
      }
    });
  }
  Future<void> agregar() async {
    _saldo += 1000;
    await _updateSaldoInFirebase();
  }

  Future<void> addRecharge(double recharge) async {
    _saldo += recharge;
    await _updateSaldoInFirebase();
  }

  Future<void> subRecharge(double value) async {
    _saldo -= value;
    await _updateSaldoInFirebase();
  }

  Future<void> _updateSaldoInFirebase() async {
    try {
      await _saldoRef?.set(_saldo);
    } catch (e) {
      debugPrint("Error updating saldo in Firebase: $e");
    }
  }
  Future<void> setZero() async {
    _saldo = 0.0;
    await _updateSaldoInFirebase();
  }
}
