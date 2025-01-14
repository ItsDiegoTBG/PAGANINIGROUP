import 'package:local_auth/local_auth.dart';
import '../../domain/usecases/authenticate_with_biometrics.dart';

import 'package:flutter/foundation.dart';

class BiometricAuthProvider extends ChangeNotifier {
  final AuthenticateWithBiometrics _authenticateWithBiometrics;

  BiometricAuthProvider(this._authenticateWithBiometrics);

  // ignore: prefer_final_fields
  bool _isAuthenticating = false;
  bool get isAuthenticating => _isAuthenticating;

  Future<void> authenticateWithBiometrics() async {
    try {
      await _authenticateWithBiometrics.call();
    } catch (e) {
      if (e.toString().contains('No stored credentials')) {
        // Muestra un mensaje al usuario
        // ignore: avoid_print
        print('Por favor, inicia sesión manualmente primero.');
      }
      throw Exception('Biometric login failed: $e');
    }
  }

  Future<void> saveCredentials(String email, String password) async {
    await _authenticateWithBiometrics.saveCredentials(email, password);
    notifyListeners();
  }
}
