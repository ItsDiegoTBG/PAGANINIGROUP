

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:paganini/data/models/credit_card_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



abstract class CreditCardRemoteDataSource {
  Future<List<CreditCardModel>> fetchCreditCards(String userid);
  Future<void> addCreditCard(CreditCardModel creditCard);
  Future<void> deleteCreditCardById(int id);
  Future<void> updateBalance(int idCreditCard, double newBalance);
}

class CreditCardRemoteDataSourceImpl implements CreditCardRemoteDataSource {

  final FirebaseFirestore firestore;
  final db = FirebaseDatabase.instance.ref();

  CreditCardRemoteDataSourceImpl(this.firestore);

  final List<CreditCardModel> _creditCards =  [
      CreditCardModel(
        id: 1,
        cardHolderFullName: 'Principal',
        cardNumber: '1234 5678 9012 3456',
        cardType: 'credit',
        validThru: '12/26',
        color: Colors.blueAccent,
        isFavorite: true,
        cvv: '123',
        balance: 200
      ),
      CreditCardModel(
        id: 2,
        cardHolderFullName: 'Jane Smith',
        cardNumber: '9876 5432 1098 7654',
        cardType: 'debit',
        validThru: '11/25',
        color: Colors.green,
        isFavorite: false,
        cvv: '456',
        balance: 123
      ),
      CreditCardModel(
        id:3,
        cardHolderFullName: 'Alice Johnson',
        cardNumber: '1111 2222 3333 4444',
        cardType: 'giftCard',
        validThru: '10/24',
        color: Colors.purple,
        isFavorite: false,
        cvv: '748',
        balance: 748
      ),
      // Más tarjetas...
    ];

  Future<List<CreditCardModel>> getUserCreditCards(String userId) async {
    final path = 'users/$userId/cards';
    final snapshot = await db.child(path).get();
    
  print(userId);
  print(snapshot.children.first.value);

 _creditCards.clear(); // Limpiar lista antes de llenarla.
      // Safely cast to Map<dynamic, dynamic>
    
     if (snapshot.exists) {
      // Safely cast and handle dynamic types
      final rawData = snapshot.value as Map<dynamic, dynamic>;

      rawData.forEach((key, value) {
        final cardMap = {
          'id': key.toString(), // Ensure the id is a string
          ...Map<String, dynamic>.from(value as Map), // Safely cast value to Map<String, dynamic>
        };

        // Append to _creditCards list
        _creditCards.add(CreditCardModel.fromMap(cardMap));
      });
    
  }return _creditCards; // Retornar la lista.
  }

  @override
  Future<List<CreditCardModel>> fetchCreditCards(String userid) async {
  
    return getUserCreditCards(userid);
  }

   @override
  Future<void> addCreditCard(CreditCardModel creditCard) async {
    _creditCards.add(creditCard);
  }

  @override
  Future<void> deleteCreditCardById(int id) async {
    _creditCards.removeWhere((card) => card.id == id);
  }
  
  @override
  Future<void> updateBalance(int idCreditCard, double newBalance) async {
    final cardIndex = _creditCards.indexWhere((card)=>card.id==idCreditCard);
      _creditCards[cardIndex].balance = newBalance;
  }

  

}
