import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:paganini/data/models/credit_card_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CreditCardRemoteDataSource {
  Future<List<CreditCardModel>> fetchCreditCards(String userid);
  Future<void> deleteCreditCardById(String userId,int index);
  Future<void> updateBalance(String userId,int idCreditCard, double newBalance);
}

class CreditCardRemoteDataSourceImpl implements CreditCardRemoteDataSource {
  final FirebaseFirestore firestore;
  final db = FirebaseDatabase.instance.ref();

  CreditCardRemoteDataSourceImpl(this.firestore);

  final List<CreditCardModel> _creditCards = [];

  Future<List<CreditCardModel>> getUserCreditCards(String userId) async {
    final path = 'users/$userId/cards';

    try {
      final snapshot = await db.child(path).get();

      // Limpiar la lista antes de llenarla
      _creditCards.clear();

      // Verificar si el snapshot existe y contiene datos
      if (!snapshot.exists || snapshot.value == null) {
        debugPrint("No hay tarjetas para este usuario.");
        return []; // Retornar lista vacía si no hay datos
      }

      // Asegurarse de que el valor sea un Map antes de procesarlo
      final rawData = snapshot.value as Map<dynamic, dynamic>;

      // Iterar sobre los datos obtenidos y agregarlos a la lista
      rawData.forEach((key, value) {
        final cardMap = {
          'id': key.toString(), // Convertir la clave a String
          ...Map<String, dynamic>.from(
              value as Map), // Convertir el valor a Map<String, dynamic>
        };

        // Agregar el modelo de tarjeta a la lista
        _creditCards.add(CreditCardModel.fromMap(cardMap));
      });

      return _creditCards; // Retornar la lista de tarjetas
    } catch (e) {
      debugPrint("Error al obtener las tarjetas: $e");
      return []; // En caso de error, retornar lista vacía
    }
  }

  @override
  Future<List<CreditCardModel>> fetchCreditCards(String userid) async {
    return getUserCreditCards(userid);
  }


  @override
  Future<void> deleteCreditCardById(String userId,int index) async {
    final cardId = _creditCards[index].id;
    debugPrint("Eliminando tarjeta $cardId");
    debugPrint("El index es: $index");
    try {
      DatabaseReference cardRef =
          FirebaseDatabase.instance.ref('users/$userId/cards/$cardId');
      await cardRef.remove(); // Eliminar tarjeta en Firebase

      _creditCards.removeWhere((card) => card.id == index); // Eliminar tarjeta localmente
      debugPrint("Tarjeta eliminada exitosamente");
    } catch (e) {
      debugPrint("Error al eliminar tarjeta: $e");
    }
  }

  @override
  Future<void> updateBalance(String userId,int idCreditCard, double newBalance) async {
  try {

    debugPrint("El cardIndex del metodo del update es: ${_creditCards[idCreditCard].id}");
    if (idCreditCard == -1) {
      debugPrint("Tarjeta no encontrada en la lista local.");
      return; // Si no se encuentra, salimos del método
    }
    _creditCards[idCreditCard].balance = newBalance;
    final cardId = _creditCards[idCreditCard].id;
    DatabaseReference cardRef = db.child('users/$userId/cards/$cardId');
    await cardRef.update({'balance': newBalance}); // Actualizar solo el balance en Firebase

    debugPrint("Balance de la tarjeta actualizado exitosamente.");
    debugPrint("El nuevo saldo de la tarjeta $idCreditCard es: $newBalance");
    debugPrint("El cardId de la tarjeta $idCreditCard es: $cardId");
  } catch (e) {
    debugPrint("Error al actualizar el balance: $e");
  }
}

}
