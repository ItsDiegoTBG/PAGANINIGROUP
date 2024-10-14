
import 'package:flutter/material.dart';

class CreditCardModel {
  final String cardHolderFullName;
  final String cardNumber;
  final String cardType; // Puede ser 'debit', 'credit', 'giftCard', etc.
  final String validThru;
  final Color color;
  final bool isFavorite;
  final String cvv;

  CreditCardModel({
    required this.cardHolderFullName,
    required this.cardNumber,
    required this.cardType,
    required this.validThru,
    required this.color,
    this.isFavorite = false,
    required this.cvv,
  });
}
