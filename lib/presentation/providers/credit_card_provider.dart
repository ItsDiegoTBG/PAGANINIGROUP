import 'package:flutter/material.dart';
import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/domain/usecases/add_credit_card.dart';
import 'package:paganini/domain/usecases/get_credit_cards.dart';

class CreditCardProvider extends ChangeNotifier {
  final GetCreditCardsUseCase getCreditCardsUseCase;
  final AddCreditCardUseCase addCreditCardUseCase;

  CreditCardProvider({
    required this.getCreditCardsUseCase,
    required this.addCreditCardUseCase,
  });

  List<CreditCardEntity> _creditCards = [];

  List<CreditCardEntity> get creditCards => _creditCards;

  Future<void> fetchCreditCards() async {
    _creditCards = await getCreditCardsUseCase.call();
    notifyListeners(); // Notificar a los listeners para actualizar la UI
  }

  Future<void> addCreditCard(CreditCardEntity creditCard) async {
    await addCreditCardUseCase.add(creditCard);
    _creditCards.add(creditCard); // Añadir la nueva tarjeta a la lista
    notifyListeners(); // Notificar a los listeners para que la UI se actualice
  }
}