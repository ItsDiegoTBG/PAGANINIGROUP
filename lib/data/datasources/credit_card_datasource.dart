import 'package:flutter/material.dart';
import 'package:paganini/data/models/credit_card_model.dart';

abstract class CreditCardRemoteDataSource {
  Future<List<CreditCardModel>> fetchCreditCards();
  Future<void> addCreditCard(CreditCardModel creditCard);
  Future<void> deleteCreditCardById(int id);
}

class CreditCardRemoteDataSourceImpl implements 

CreditCardRemoteDataSource {
  final List<CreditCardModel> _creditCards =  [
      CreditCardModel(
        id: 1,
        cardHolderFullName: 'Principal',
        cardNumber: '1234 5678 9012 3456',
        cardType: 'credit',
        validThru: '12/26',
        color: Colors.blueAccent,
        isFavorite: true,
        cvv: '123',
      ),
      CreditCardModel(
        id: 2,
        cardHolderFullName: 'Jane Smith',
        cardNumber: '9876 5432 1098 7654',
        cardType: 'debit',
        validThru: '11/25',
        color: Colors.green,
        isFavorite: false,
        cvv: '456',
      ),
      CreditCardModel(
        id:3,
        cardHolderFullName: 'Alice Johnson',
        cardNumber: '1111 2222 3333 4444',
        cardType: 'giftCard',
        validThru: '10/24',
        color: Colors.purple,
        isFavorite: false,
        cvv: '789',
      ),
      CreditCardModel(
        id: 4,
        cardHolderFullName: 'Bob Brown',
        cardNumber: '5555 6666 7777 8888',
        cardType: 'credit',
        validThru: '09/23',
        color: Colors.orange,
        isFavorite: true,
        cvv: '321',
      ),
      // Más tarjetas...
    ];
  @override
  Future<List<CreditCardModel>> fetchCreditCards() async {
    return _creditCards;
  }

   @override
  Future<void> addCreditCard(CreditCardModel creditCard) async {
    _creditCards.add(creditCard);
  }

  @override
  Future<void> deleteCreditCardById(int id) async {
    _creditCards.removeWhere((card) => card.id == id);
  }

  

}
