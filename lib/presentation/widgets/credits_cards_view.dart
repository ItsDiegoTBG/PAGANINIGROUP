import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';
import 'package:paganini/presentation/pages/services/encryption_service.dart';

class CreditCardsView extends StatelessWidget {
  const CreditCardsView({
    super.key,
    required PageController pageController,
    required this.creditCards,
  }) : _pageController = pageController;

  final PageController _pageController;
  final List<CreditCardEntity> creditCards;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: PageView.builder(
          controller: _pageController,
          itemCount:
              creditCards.length, // Si está vacía, mostrar solo 1 tarjeta
          itemBuilder: (context, index) {
            final card = creditCards.isEmpty
                ? CreditCardEntity(
                    balance: 0,
                    id: 4,
                    cardHolderFullName: 'Paganini',
                    cardNumber: '999999999999999999',
                    cardType: 'credit',
                    validThru: '99/99',
                    color: AppColors.primaryColor,
                    isFavorite: false,
                    cvv: '999',
                  ) // Si no hay tarjetas, mostrar la ficticia
                : creditCards[index];
            return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.3))
                        .clamp(0.7, 1.0); // Reduce la escala
                  } else {
                    value = index == 0 ? 1.0 : 0.7;
                  }
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: 1,
                      child: CreditCardWidget(
                        balance: card.balance,
                        cardHolderFullName: card.cardHolderFullName,
                        cardNumber: card.cardNumber,
                        validThru: card.validThru,
                        cardType: card.cardType,
                        cvv: card.cvv,
                        color: card.color,
                        isFavorite: card.isFavorite,
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
