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

  Future<void> fetchCreditCards() async {
    _creditCards = await creditCardsUseCase.call();
    notifyListeners(); // Notificar a los listeners para actualizar la UI
  }

  Future<void> addCreditCard(CreditCardEntity creditCard) async {
    await creditCardsUseCase.add(creditCard);
    _creditCards.add(creditCard); // Añadir la nueva tarjeta a la lista
    notifyListeners(); // Notificar a los listeners para que la UI se actualice
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
      throw Exception('Error al actualizar el saldo: $e');
    }
  }
}
