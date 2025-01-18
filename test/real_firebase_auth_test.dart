import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final FirebaseAuth auth = MockFirebaseAuth();
  group('Firebase Auth Tests', () {
    test('User can register and save data to database', () async {
      const email = 'carlos@gmail.com';
      const password = 'uurRL9yK9ca\$';
      const firstName = 'Carlos';
      const lastName = 'Barciona';
      const ced = '0954623412';
      const phone = '0990095632';
      const saldo = 0.0;  
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      // Simula el guardado de datos en Realtime Database
      Map<String, dynamic> userData = {
        'firstname': firstName,
        'lastname': lastName,
        'ced': ced,
        'email': email,
        'phone': phone,
        'saldo': saldo,
        'cards': [],
      };
      // Mock database
      final mockDatabase = <String, Map<String, dynamic>>{};
      mockDatabase['users/$uid'] = userData;
      // Comprueba que los datos se hayan guardado correctamente
      expect(mockDatabase['users/$uid'], isNotNull);
      expect(mockDatabase['users/$uid']?['firstname'], firstName);
      expect(mockDatabase['users/$uid']?['lastname'], lastName);
      expect(mockDatabase['users/$uid']?['ced'], ced);
      expect(mockDatabase['users/$uid']?['email'], email);
      expect(mockDatabase['users/$uid']?['phone'], phone);
      expect(mockDatabase['users/$uid']?['saldo'], saldo);
      expect(mockDatabase['users/$uid']?['cards'], isEmpty);
    });

    test('User can sign in successfully', () async {
      const email = 'testuser@example.com';
      const password = 'securePassword123';

      // Simula la creación del usuario
      await auth.createUserWithEmailAndPassword(email: email, password: password);

      // Simula el inicio de sesión
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Comprueba que el usuario haya iniciado sesión
      expect(userCredential.user, isNotNull);
      expect(userCredential.user?.email, email);
    });

    test('Sign in fails with incorrect credentials', () async {
      const email = 'carlos@gmail.com';
      const password = 'wrongPassword';

      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } catch (e) {
        expect(e, isInstanceOf<FirebaseAuthException>());
      }
    });
  });
}
