import 'package:paganini/data/datasources/credit_card_datasource.dart';
import 'package:paganini/data/models/credit_card_model.dart';
import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/domain/repositories/credit_card_repository.dart';

class CreditCardRepositoryImpl implements CreditCardRepository {
  final CreditCardRemoteDataSource remoteDataSource;

  CreditCardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CreditCardEntity>> getCreditCards() async {
    final creditCardModels = await remoteDataSource.fetchCreditCards();

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
            ))
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
    );

    try {
      await remoteDataSource.addCreditCard(creditCardModel);
    } catch (e) {
      throw Exception('Error al agregar la tarjeta: $e');
    }
  }
}
