import 'package:flutter/material.dart';
import 'package:paganini/domain/entity/card_credit.dart';

import 'package:paganini/domain/usecases/credit_cards_use_case.dart';

class CreditCardProvider extends ChangeNotifier {
  final CreditCardsUseCase creditCardsUseCase;

  CreditCardProvider({
    required this.creditCardsUseCase,
  });

  List<CreditCardEntity> _creditCards = [];

  List<CreditCardEntity> get creditCards => _creditCards;

  int getNextId() {
    if (_creditCards.isEmpty) return 1;
    return _creditCards.map((card) => card.id).reduce((a, b) => a > b ? a : b) +
        1;
  }

  Future<void> fetchCreditCards() async {
    _creditCards = await creditCardsUseCase.call();
    notifyListeners(); // Notificar a los listeners para actualizar la UI
  }

  Future<void> addCreditCard(CreditCardEntity creditCard) async {
    try {
      creditCard.id = getNextId();
      await creditCardsUseCase.add(creditCard);
      final exists = _creditCards.any((card) => card.id == creditCard.id);
      if (exists) {
        throw Exception('El ID de la tarjeta ya existe en la lista local');
      }

      _creditCards.add(creditCard);
      notifyListeners();
    } catch (e) {
      throw Exception('Error al agregar la tarjeta: $e');
    }
  }

  Future<bool> deleteCreditCard(int idCreditCard) async {
    final deleted = await creditCardsUseCase.delete(idCreditCard);
    if (deleted) {
      _creditCards.removeWhere((card) => card.id == idCreditCard);
    }
    notifyListeners();
    return deleted;
  }

  Future<void> updateBalance(int idCreditCard, double newBalance) async {
    try {
      await creditCardsUseCase.updateBalance(idCreditCard, newBalance);
      notifyListeners();
    } catch (e) {
      throw Exception('Error al actualizar el saldo de la tarjeta: $e');
    }
  }
}
