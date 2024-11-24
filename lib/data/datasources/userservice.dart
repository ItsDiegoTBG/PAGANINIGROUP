import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Map<String, dynamic>?> fetchUserById(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(userId).get();

    if (snapshot.exists) {
        return snapshot.data();
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
