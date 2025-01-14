import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/domain/usecases/credit_cards_use_case.dart';
import 'package:paganini/presentation/pages/services/encryption_service.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version_icon.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';
import 'package:paganini/presentation/widgets/smooth_page_indicator.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

late CreditCardsUseCase creditCardsUseCase;
late Future<List<CreditCardEntity>> creditCardsFuture;

class _WalletPageState extends State<WalletPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
    final creditCardProvider =
        Provider.of<CreditCardProvider>(context, listen: false);
    creditCardProvider.fetchCreditCards(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saldoProviderWatch = context.watch<SaldoProvider>();
    final creditCardProviderWatch = context.watch<CreditCardProvider>();

    // Obtenemos la lista de tarjetas actualizada directamente del provider
    final creditCards = creditCardProviderWatch.creditCards;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    height: 120,
                    width: 350,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 40, top: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Saldo',
                              style: TextStyle(
                                color: Colors.white, // Color del texto
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            height:
                                5), // Espacio entre el texto de saldo y el valor
                        Text(
                          "\$${saldoProviderWatch.saldo}", // Aquí pones el valor que quieres mostrar
                          style: const TextStyle(
                            color: Colors.white, // Color del texto
                            fontSize: 37,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ButtonSecondVersion(
                            horizontalPadding: 20,
                            text: "Agregar",
                            function: () {
                              Navigator.pushNamed(context, Routes.RECHARGE);
                            }),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ButtonSecondVersion(
                          horizontalPadding: 20,
                          text: "Transferir",
                          function: () {
                            Navigator.pushNamed(context, Routes.TRANSFERPAGE);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          //Text(creditCards.length.toString()),
          creditCards.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Text(
                      "No tiene tarjetas registradas",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                )
              : const Text(""),

          //tarjetas
          if (creditCards.isNotEmpty)
            Column(
              children: [
                SizedBox(
                  height: 190,
                  child: PageView.builder(
                      controller: _pageController,
                      itemCount: creditCards.isEmpty
                          ? 1
                          : creditCards
                              .length, // Si está vacía, mostrar solo 1 tarjeta
                      itemBuilder: (context, index) {
                        final card = creditCards[index];
                        debugPrint("El card es: ${card.isFavorite}");
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
                                    supportNfc: true,
                                    width: 400,
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
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: SmoothPageIndicatorWidget(
                    pageController: _pageController,
                    totalCounts: creditCards.isEmpty ? 1 : creditCards.length,
                    smoothPageEffect: const WormEffect(
                      activeDotColor: AppColors.primaryColor,
                      dotColor: AppColors.secondaryColor,
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonSecondVersionIcon(
                    horizontalPadding: 12,
                    function: () {
                      Navigator.pushNamed(context, Routes.CARDDELETEPAGE);
                    },
                    text: "Eliminar",
                    icon: Icons.delete_rounded,
                    iconAlignment: IconAlignment.end),
                ButtonSecondVersionIcon(
                    horizontalPadding: 12,
                    function: () {
                      Navigator.pushNamed(context, Routes.CARDPAGE);
                    },
                    text: "Agregar",
                    icon: Icons.add_card_rounded,
                    iconAlignment: IconAlignment.start),
              ],
            ),
          )
        ],
      ),
    );
  }
}
