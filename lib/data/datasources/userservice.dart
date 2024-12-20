import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Método para obtener un usuario por ID
  Future<Map<String, dynamic>?> fetchUserById(String userId) async {
    try {
      // Obtener la referencia al usuario en la base de datos en tiempo real
      DatabaseReference userRef = _database.ref('users/$userId');

      // Obtener los datos del usuario
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        // Si el usuario existe, retornar los datos
        return Map<String, dynamic>.from(snapshot.value as Map);
      } else {
        debugPrint('Usuario no encontrado');
        return null;
      }
    } catch (e) {
      debugPrint('Error al buscar el usuario: $e');
      return null;
    }
  }
}
