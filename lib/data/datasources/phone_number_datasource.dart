import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

abstract class PhoneNumberRemoteDataSource {
  Future<List<String>> fetchPhoneNumbers(
      String userId); // Método para obtener los números de teléfono
}

class PhoneNumberRemoteDataSourceImpl implements PhoneNumberRemoteDataSource {
  final db = FirebaseDatabase.instance.ref();

  PhoneNumberRemoteDataSourceImpl();

  // Método para obtener números de teléfono desde Firebase
  Future<Set<String>> getPhoneNumbersFromFirebase(String userId) async {
    final path =
        'users/$userId/phone'; // Asumiendo que los contactos están bajo 'phone'

    try {
      final snapshot = await db.child(path).get();

      if (!snapshot.exists || snapshot.value == null) {
        debugPrint("No hay contactos para este usuario.");
        return {}; // Retorna un set vacío si no hay datos
      }

      final rawData = snapshot.value as Map<dynamic, dynamic>;

      Set<String> phoneNumbers = {};
      rawData.forEach((key, value) {
        final contact = Map<String, dynamic>.from(value as Map);
        final phone = contact['phone'];
        if (phone != null) {
          phoneNumbers
              .add(phone.toString()); // Agregar número de teléfono al set
        }
      });

      return phoneNumbers; // Retorna el set de números de teléfono
    } catch (e) {
      debugPrint("Error al obtener los números de teléfono: $e");
      return {}; // En caso de error, retorna un set vacío
    }
  }

  @override
  Future<List<String>> fetchPhoneNumbers(String userId) async {
    return getPhoneNumbersFromFirebase(userId).then((set) => set.toList());
  }
}
