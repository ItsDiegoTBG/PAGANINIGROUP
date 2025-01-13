import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SaldoProvider with ChangeNotifier {
  final DatabaseReference _saldoRef =
      FirebaseDatabase.instance.ref().child('saldo');
  
  double _saldo = 0.0;
 
  double get saldo => _saldo;

    SaldoProvider() {
    _saldoRef.onValue.listen((event) {
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
      await _saldoRef.set(_saldo);
    } catch (e) {
      debugPrint("Error updating saldo in Firebase: $e");
    }
  }
}
