import 'package:paganini/domain/entity/card_credit.dart';

abstract class CreditCardRepository {
  Future<List<CreditCardEntity>> getCreditCards();
  Future<void> addCreditCard(CreditCardEntity creditCard);
  Future<bool> deleteCreditCard(int idCreditCard);
  Future<void> updateBalance(int idCreditCard, double newBalance); // Nuevo método para actualizar el saldo
}
