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
  const CreditCardWidget({
    super.key,
    required this.cardHolderFullName,
    required this.cardNumber,
    required this.validThru,
    required this.color,
    this.isFavorite,
    required this.cardType,
    required this.cvv,
    this.width = 300
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
      width: 300,
      cardHolderFullName: cardHolderFullName,
      doesSupportNfc: true,
      cardNumber: cardNumber,
      validThru: validThru,
      cardType: whatCardTypeIs(cardType),
      topLeftColor: const Color.fromARGB(255, 26, 24, 24),
      bottomRightColor: color,
      cvvNumber: cvv,
      cardProviderLogo: isFavorite == true
          ? const Icon(
              Icons.star,
              color: Colors.yellow,
              size: 30,
            )
          : const SizedBox(),
      cardProviderLogoPosition: CardProviderLogoPosition.right    
    );
  }
}
