// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<void> authenticateWithBiometrics();
  Future<void> loginWithEmailAndPassword(String email, String password);
  Future<void> saveCredentials(String email, String password);
}