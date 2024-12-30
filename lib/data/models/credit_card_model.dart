import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';

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
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
  factory CreditCardModel.fromMap(Map<String, dynamic> map) {
    return CreditCardModel(
      id: int.tryParse(map['id'].toString()) ?? 0,
      cardHolderFullName: map['cardHolderFullName'] ?? '',
      cardNumber: map['cardNumber'].toString(),
      cardType: map['cardType'] ?? '',
      validThru: map['validThru'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      cvv: map['cvv'].toString(),
      balance: map['balance']?.toDouble() ?? 0.0,
      color: getColorFromString(map['color'].toString()),
    );
  }


}

Color getColorFromString(String color) {
  switch (color) {
    case 'red':
      return Colors.red;
    case 'green':
      return Colors.green;
    case 'black':
      return Colors.black;
    case 'blue':
      return Colors.blue;
    case 'yellow':
      return Colors.amber;
    case 'primary':
      return AppColors.primaryColor;
    default:
      return AppColors.primaryColor;
  }
}