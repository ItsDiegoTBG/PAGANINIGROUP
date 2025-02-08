import 'package:paganini/domain/entity/card_credit.dart';

abstract class CreditCardRepository {
  Future<List<CreditCardEntity>> getCreditCards(String userid);
  //Future<void> addCreditCard(CreditCardEntity creditCard);
  Future<bool> deleteCreditCard(String userId,int index);
  Future<void> updateName(String userId,int idCreditCard, String newName); 
  Future<void> updateBalance(String userId,int idCreditCard, double newBalance); 
}
