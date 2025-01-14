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
      final newSaldo = double.tryParse(event.snapshot.value.toString());
      if (newSaldo != null && newSaldo != _saldo) {
        _saldo = newSaldo;
        notifyListeners(); // Solo notifica cambios si el saldo realmente cambia
      }
    }, onError: (error) {
      debugPrint("Error al escuchar cambios en el saldo: $error");
    });
  }

  Future<void> agregar() async {
    await _updateSaldoLocallyAndFirebase(_saldo + 1000);
  }

  Future<void> addRecharge(double recharge) async {
    await _updateSaldoLocallyAndFirebase(_saldo + recharge);
  }

  Future<void> subRecharge(double value) async {
    if (value > _saldo) {
      debugPrint("No se puede reducir más de lo que hay en el saldo.");
      return;
    }
    await _updateSaldoLocallyAndFirebase(_saldo - value);
  }

  Future<void> setZero() async {
    await _updateSaldoLocallyAndFirebase(0.0);
  }

  Future<void> _updateSaldoLocallyAndFirebase(double newSaldo) async {
    _saldo = newSaldo;
    notifyListeners(); // Notifica a los oyentes solo una vez
    try {
      await _saldoRef?.set(_saldo);
    } catch (e) {
      debugPrint("Error al actualizar el saldo en Firebase: $e");
    }
  }
}
