import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/domain/repositories/credit_card_repository.dart';

class AddCreditCardUseCase {
  final CreditCardRepository repository;

  AddCreditCardUseCase({required this.repository});

  Future<void> add(CreditCardEntity creditCard) async {
    await repository.addCreditCard(creditCard);
  }
}
