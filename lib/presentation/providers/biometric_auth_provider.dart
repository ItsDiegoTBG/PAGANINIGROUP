import 'package:local_auth/local_auth.dart';
import '../../domain/usecases/authenticate_with_biometrics.dart';


import 'package:flutter/foundation.dart'; 

class BiometricAuthProvider extends ChangeNotifier {
  final AuthenticateWithBiometrics _authenticateWithBiometrics;

  BiometricAuthProvider(this._authenticateWithBiometrics);

  bool _isAuthenticating = false;
  bool get isAuthenticating => _isAuthenticating;

  Future<void> authenticateWithBiometrics() async {
    _isAuthenticating = true;
    notifyListeners(); // Notify UI that authentication has started

    try {
      await _authenticateWithBiometrics.call();
    } catch (e) {
      throw Exception('Biometric login failed: $e');
    } finally {
      _isAuthenticating = false;
      notifyListeners(); // Notify UI that authentication is complete
    }
  }
}