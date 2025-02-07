import '../repositories/auth_repository_impl.dart';

class AuthenticateWithBiometrics {
  final AuthRepository repository;

  AuthenticateWithBiometrics(this.repository);

  Future<void> call() async {
    return repository.authenticateWithBiometrics();
  }
  Future<void> saveCredentials(String email, String password) async {
    await repository.saveCredentials(email, password);
  }
}

class AuthenticateTransferWithBiometrics {
  final AuthRepository repository;

  AuthenticateTransferWithBiometrics(this.repository);

  Future<void> call() async {
    return repository.authenticateTransferWithBiometrics();
  }
  Future<void> saveCredentials(String email, String password) async {
    await repository.saveCredentials(email, password);
  }
}

