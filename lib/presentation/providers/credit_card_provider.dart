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

  Future<void> fetchCreditCards(String userid) async {
    _creditCards = await creditCardsUseCase.call(userid);
    notifyListeners(); // Notificar a los listeners para actualizar la UI
  }

  Future<void> addCreditCard(String userId) async {
    fetchCreditCards(userId);
    notifyListeners();
  }

  Future<bool> deleteCreditCard(String userId, int index) async {
    final deleted = await creditCardsUseCase.delete(userId, index);
    if (deleted) {
      _creditCards.removeWhere((card) => card.id == index);
    }
    fetchCreditCards(userId);
    notifyListeners();
    return deleted;
  }

  /*Future<void> updateName(
      String userId, int idCreditCard, String name) asunc {
    try {
    
    notifyListeners();
    } catch (e) {
      throw Exception('Error al actualizar el nombre de la tarjeta: $e');
    }
    }*/

  Future<void> updateBalance(
      String userId, int idCreditCard, double newBalance) async {
    try {
      await creditCardsUseCase.updateBalance(userId, idCreditCard, newBalance);
      fetchCreditCards(userId);
      notifyListeners();
    } catch (e) {
      throw Exception('Error al actualizar el saldo de la tarjeta: $e');
    }
  }
}
