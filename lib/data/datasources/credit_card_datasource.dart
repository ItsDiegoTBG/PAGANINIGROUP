import 'package:flutter/material.dart';
import 'package:paganini/data/models/credit_card_model.dart';

abstract class CreditCardRemoteDataSource {
  Future<List<CreditCardModel>> fetchCreditCards();
  Future<void> addCreditCard(CreditCardModel creditCard);
  Future<void> deleteCreditCardById(int id);
  Future<void> updateBalance(int idCreditCard, double newBalance);
}

class CreditCardRemoteDataSourceImpl implements CreditCardRemoteDataSource {
  final List<CreditCardModel> _creditCards = [
    CreditCardModel(
        id: 1,
        cardHolderFullName: 'Principal',
        cardNumber: '4564 5678 9012 3456',
        cardType: 'credit',
        validThru: '12/26',
        color: Colors.blueAccent,
        isFavorite: true,
        cvv: '123',
        balance: 200),
    CreditCardModel(
        id: 2,
        cardHolderFullName: 'Jane Smith',
        cardNumber: '5576 5432 1098 7654',
        cardType: 'debit',
        validThru: '11/25',
        color: Colors.green,
        isFavorite: false,
        cvv: '456',
        balance: 123),

    // Más tarjetas...
  ];
  @override
  Future<List<CreditCardModel>> fetchCreditCards() async {
    return _creditCards;
  }

  @override
  Future<void> addCreditCard(CreditCardModel creditCard) async {
    final exists = _creditCards.any((card) => card.id == creditCard.id);
    if (exists) {
      throw Exception('El ID de la tarjeta ya existe');
    }
    _creditCards.add(creditCard);
  }

  @override
  Future<void> deleteCreditCardById(int id) async {
    _creditCards.removeWhere((card) => card.id == id);
  }

  @override
  Future<void> updateBalance(int idCreditCard, double newBalance) async {
    debugPrint(
        'Tarjetas disponibles: ${_creditCards.map((card) => card.id).toList()}');
    final cardIndex =
        _creditCards.indexWhere((card) => card.id == idCreditCard);

    if (cardIndex == -1) {
      debugPrint('Error: No se encontró la tarjeta con ID $idCreditCard');
      throw Exception('No se encontró la tarjeta con ID: $idCreditCard');
    }

    _creditCards[cardIndex].balance = newBalance;
  }

// IMPLEMENTACION DE GET DE TARJETAS DEL FIREBASE
}
