import 'package:flutter/material.dart';

class CreditCardModel {
  final int id;
  final String cardHolderFullName;
  final String cardNumber;
  final String cardType;
  final String validThru;
  final Color color;
  final bool isFavorite;
  final String cvv;

  CreditCardModel({
    required this.id,
    required this.cardHolderFullName,
    required this.cardNumber,
    required this.cardType,
    required this.validThru,
    required this.color,
    required this.isFavorite,
    required this.cvv,
  });

  factory CreditCardModel.fromJson(Map<String, dynamic> json) {
    return CreditCardModel(
      id: json['id'],
      cardHolderFullName: json['cardHolderFullName'],
      cardNumber: json['cardNumber'],
      cardType: json['cardType'],
      validThru: json['validThru'],
      color: Color(json['color']),
      isFavorite: json['isFavorite'],
      cvv: json['cvv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,      
      'cardHolderFullName': cardHolderFullName,
      'cardNumber': cardNumber,
      'cardType': cardType,
      'validThru': validThru,
      'color': color.value,
      'isFavorite': isFavorite,
      'cvv': cvv,
    };
  }
}
