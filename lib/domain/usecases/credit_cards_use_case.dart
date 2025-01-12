import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/domain/repositories/credit_card_repository.dart';

class CreditCardsUseCase {
  final CreditCardRepository repository;

  CreditCardsUseCase({required this.repository});

  Future<List<CreditCardEntity>> call(String userid) async {
    return await repository.getCreditCards(userid);
  }
  /* Future<void> add(CreditCardEntity creditCard) async {
    await repository.addCreditCard(creditCard);
  }*/
  Future<bool> delete(String userId, int index) async {
    return  await repository.deleteCreditCard(userId, index);
  }

  Future<void> updateBalance(String userId,int idCreditCard, double newBalance) async {
    await repository.updateBalance(userId,idCreditCard, newBalance);
  }
}
