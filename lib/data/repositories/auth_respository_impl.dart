// data/repositories/auth_repository_impl.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../../domain/repositories/auth_repository_impl.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final LocalAuthentication _localAuth;
  final FlutterSecureStorage _secureStorage;

  AuthRepositoryImpl(this._auth, this._localAuth, this._secureStorage);

  @override
Future<void> authenticateWithBiometrics() async {
  bool isAuthenticated = await _localAuth.authenticate(
    localizedReason: 'Autenticate para acceder a tu cuenta paganini',
    options: const AuthenticationOptions(
      stickyAuth: true,
    ),
  
  );
  debugPrint("El metodo authenticateWithBiometrics fue llamado , isAuthenticated: $isAuthenticated");
  if (isAuthenticated) {
    final email = await _secureStorage.read(key: 'email');
    final password = await _secureStorage.read(key: 'password');

    if (email != null && password != null) {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } else {
      throw Exception('No stored credentials found. Please log in with your email and password first.');
    }
  } else {
    throw Exception('Biometric authentication failed.');
  }
}


  @override
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    await saveCredentials(email, password);
  }

  @override
  Future<void> saveCredentials(String email, String password) async {
    await _secureStorage.write(key: 'email', value: email);
    await _secureStorage.write(key: 'password', value: password);
  }
}
