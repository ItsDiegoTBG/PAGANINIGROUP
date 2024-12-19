import 'package:flutter/material.dart';

class CreditCardModel {
  final int id;
  final String cardHolderFullName;
  final String cardNumber;
  final String cardType;
  final String validThru;
  final bool isFavorite;
  final String cvv;
  double balance;
  final Color color;
  CreditCardModel({
    required this.id,
    required this.cardHolderFullName,
    required this.cardNumber,
    required this.cardType,
    required this.validThru,
    required this.isFavorite,
    required this.cvv,
    required this.balance,
    this.color = Colors.black,
  });

  Map<String, dynamic> toMap() {
    return {
      'cardHolderFullName': cardHolderFullName,
      'cardNumber': cardNumber,
      'cardType': cardType,
      'validThru': validThru,
      'isFavorite': isFavorite,
      'cvv': cvv,
      'balance': balance,
    };
  }

  // Método fromMap: convierte un Map en un objeto CreditCardModel
  factory CreditCardModel.fromMap(Map<String, dynamic> map, int id) {
    return CreditCardModel(
      id: id,
      cardHolderFullName: map['cardHolderFullName'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      cardType: map['cardType'] ?? '',
      validThru: map['validThru'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      cvv: map['cvv'] ?? '',
      balance: map['balance']?.toDouble() ?? 0.0,
    );
  }
}
