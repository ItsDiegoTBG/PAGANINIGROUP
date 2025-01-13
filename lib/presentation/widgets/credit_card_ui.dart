import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';


class CreditCardWidget extends StatelessWidget {
  final String cardHolderFullName;
  final String cardNumber;
  final String cardType;
  final String validThru;
  final Color color;
  final bool? isFavorite;
  final String cvv;
  final double width;
  final double balance;
  final bool supportNfc;
  const CreditCardWidget({
    super.key,
    required this.cardHolderFullName,
    required this.cardNumber,
    required this.validThru,
    required this.color,
    this.isFavorite,
    required this.cardType,
    required this.cvv,
    this.width = 300,
    required this.balance,
    this.supportNfc = true,
  });

  @override
  Widget build(BuildContext context) {
    CardType whatCardTypeIs(String cardType) {
      switch (cardType) {
        case 'debit':
          return CardType.debit;
        case 'credit':
          return CardType.credit;
        case 'giftCard':
          return CardType.giftCard;
        default:
          return CardType.other;
      }
    }

    
    return CreditCardUi(
      autoHideBalance: true,
      showValidFrom: false,
      showBalance: true,
      balance: balance,
      width: width,
      cardHolderFullName: cardHolderFullName,
      doesSupportNfc: supportNfc,
      cardNumber: cardNumber,
      validThru: validThru,
      cardType: whatCardTypeIs(cardType),
      topLeftColor: color,
      bottomRightColor: color,
      cardProviderLogo: isFavorite == true
          ? const Icon(
              Icons.star,
              color: Colors.yellow,
              size: 30,
            )
          : const SizedBox(),
      cardProviderLogoPosition: CardProviderLogoPosition.right,
    );
  }
}
