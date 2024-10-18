import 'package:paganini/domain/entity/card_credit.dart';

abstract class CreditCardRepository {
  Future<List<CreditCardEntity>> getCreditCards();
  Future<void> addCreditCard(CreditCardEntity creditCard);
}
