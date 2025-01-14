import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:paganini/domain/entity/user_entity.dart';

import 'package:paganini/presentation/widgets/contact_user.dart';

class ContactProvider with ChangeNotifier {
  ContactUserWidget? _contactTransfered;
  ContactUserWidget? get contactTransfered => _contactTransfered;

  UserEntity? _contactUser;
  UserEntity? get contactUser => _contactUser;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Future<void> setContactTransfered(ContactUserWidget contact) async {
    _contactTransfered = contact;
    notifyListeners();

    String phoneNumber = contactTransfered!.phoneUser;
    try {
      // Realizamos la consulta para obtener el usuario por teléfono
      final snapshot = await _database
          .ref('users') // Ruta donde están almacenados los usuarios
          .orderByChild('phone') // Ordenar por el campo phone
          .equalTo(phoneNumber) // Comparar con el número de teléfono
          .get();

      debugPrint("Buscando al usuario $phoneNumber");

      if (snapshot.exists && snapshot.children.isNotEmpty) {
        debugPrint("El snapshot existe y tiene datos");

        // Accedemos al primer hijo de la consulta, que debería ser el usuario
        final userData = snapshot.children.first.value as Map<dynamic, dynamic>;
        debugPrint("Datos del usuario: $userData");

        _contactUser = UserEntity(
          id: snapshot.children.first.key ?? '',
          firstname: userData['firstname'] ?? '',
          lastname: userData['lastname'] ?? '',
          ced: userData['ced'] ?? '',
          email: userData['email'] ?? '',
          phone: userData['phone'] ?? '',
          saldo: (userData['saldo'] ?? 0).toDouble(),
        );
        debugPrint("Datos del contacto cargados exitosamente");
      } else {
        debugPrint("No existe un usuario con el teléfono proporcionado");
        _contactUser = null;
      }
    } catch (e) {
      _contactUser = null;
      debugPrint('Error al cargar datos del usuario: $e');
    }
    notifyListeners();
  }
  Future<bool> contactUserNotExist(String phoneNumber) async {
    try {
      final snapshot = await _database.ref('users') // Ruta donde están almacenados los usuarios
          .orderByChild('phone') // Ordenar por el campo phone
          .equalTo(phoneNumber) // Comparar con el número de teléfono
          .get(); // Obtener los datos  
      return snapshot.exists && snapshot.value != null;
    } catch (e) {
      debugPrint('Error al verificar si el usuario existe: $e');
      return false;
    }
  }
  void resetContact() {
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      _contactTransfered = null;
      _contactUser = null;
      notifyListeners();
    }
  }

   Future<void> updateUserSaldo(UserEntity contactUser, double amount) async {
    try {
      double newSaldo = contactUser.saldo + amount;
      await _database.ref('users').child(contactUser.id).update({'saldo': newSaldo});
      debugPrint("Saldo actualizado exitosamente para el usuario receptor");
    } catch (e) {
      debugPrint('Error al actualizar el saldo del usuario: $e');
    }
  }
}
