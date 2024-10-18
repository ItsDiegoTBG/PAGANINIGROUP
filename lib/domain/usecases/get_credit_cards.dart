import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/domain/repositories/credit_card_repository.dart';

class GetCreditCardsUseCase {
  final CreditCardRepository repository;

  GetCreditCardsUseCase({required this.repository});

  Future<List<CreditCardEntity>> call() async {
    return await repository.getCreditCards();
  }
}
