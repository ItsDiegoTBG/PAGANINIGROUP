import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/domain/repositories/credit_card_repository.dart';

class CreditCardsUseCase {
  final CreditCardRepository repository;

  CreditCardsUseCase({required this.repository});

  Future<List<CreditCardEntity>> call() async {
    return await repository.getCreditCards();
  }
   Future<void> add(CreditCardEntity creditCard) async {
    await repository.addCreditCard(creditCard);
  }
  Future<bool> delete(int idCreditCard) async {
    return  await repository.deleteCreditCard(idCreditCard);
  }
}
