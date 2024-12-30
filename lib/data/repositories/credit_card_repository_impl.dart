import 'package:paganini/data/datasources/credit_card_datasource.dart';
import 'package:paganini/data/models/credit_card_model.dart';
import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/domain/repositories/credit_card_repository.dart';

class CreditCardRepositoryImpl implements CreditCardRepository {
  final CreditCardRemoteDataSource remoteDataSource;

  CreditCardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CreditCardEntity>> getCreditCards(String userid) async {
    final creditCardModels = await remoteDataSource.fetchCreditCards(userid);

    // Convertimos los modelos a entidades de dominio
    return creditCardModels
        .map((model) => CreditCardEntity(
            id: model.id,
            cvv: model.cvv,
            color: model.color,
            cardHolderFullName: model.cardHolderFullName,
            cardNumber: model.cardNumber,
            cardType: model.cardType,
            validThru: model.validThru,
            isFavorite: model.isFavorite,
            balance: model.balance))
        .toList();
  }

  @override
  Future<void> addCreditCard(CreditCardEntity creditCard) async {
    // Convertir CreditCardEntity a CreditCardModel
    final creditCardModel = CreditCardModel(
      id: creditCard.id,
      cvv: creditCard.cvv,
      color: creditCard.color,
      cardHolderFullName: creditCard.cardHolderFullName,
      cardNumber: creditCard.cardNumber,
      cardType: creditCard.cardType,
      validThru: creditCard.validThru,
      isFavorite: creditCard.isFavorite,
      balance: creditCard.balance,
    );

    try {
      await remoteDataSource.addCreditCard(creditCardModel);
    } catch (e) {
      throw Exception('Error al agregar la tarjeta: $e');
    }
  }

  @override
  Future<bool> deleteCreditCard(int idCreditCard) async {
    try {
      await remoteDataSource.deleteCreditCardById(idCreditCard);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateBalance(int idCreditCard, double newBalance) async {
    // TODO: implement updateBalance
    try {
      await remoteDataSource.updateBalance(idCreditCard, newBalance);
    } catch (e) {
      throw Exception('Error al agregar la tarjeta: $e');
    }
  }
}
