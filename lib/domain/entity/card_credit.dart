
import 'package:flutter/material.dart';

class CreditCardEntity  {
  final int id;
  final String cardHolderFullName;
  final String cardNumber;
  final String cardType; 
  final String validThru;
  final Color color;
  final bool isFavorite;
  final String cvv;
  final double balance;

  CreditCardEntity({
    required this.id,
    required this.cardHolderFullName,
    required this.cardNumber,
    required this.cardType,
    required this.validThru,
    required this.color,
    this.isFavorite = false,
    required this.cvv,
    required this.balance
  });
}
