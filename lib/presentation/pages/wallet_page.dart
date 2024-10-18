import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/domain/usecases/add_credit_card.dart';
import 'package:paganini/domain/usecases/get_credit_cards.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version_icon.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';
import 'package:paganini/presentation/widgets/smooth_page_indicator.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

late GetCreditCardsUseCase getCreditCardsUseCase;
late Future<List<CreditCardEntity>> creditCardsFuture;

class _WalletPageState extends State<WalletPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
    final creditCardProvider =
        Provider.of<CreditCardProvider>(context, listen: false);
    creditCardProvider.fetchCreditCards();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saldoProviderWatch = context.watch<SaldoProvider>();
    final saldoProviderRead = context.read<SaldoProvider>();
    final creditCardProviderWatch = context.watch<CreditCardProvider>();

    // Obtenemos la lista de tarjetas actualizada directamente del provider
    final creditCards = creditCardProviderWatch.creditCards;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const ContentAppBar(),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  height: 130,
                  width: 360,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      const Padding(
                        padding: const EdgeInsets.only(left: 40, top: 8),
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
                              10), // Espacio entre el texto de saldo y el valor
                      Text(
                        "\$${saldoProviderWatch.saldo}", // Aquí pones el valor que quieres mostrar
                        style: const TextStyle(
                            color: Colors.white, // Color del texto
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonSecondVersion(
                      text: "Agregar",
                      function: () {
                        saldoProviderRead.agregar();
                      }),
                  const SizedBox(
                    width: 10,
                  ),
                  ButtonSecondVersion(
                    text: "Transferir",
                    function: () {},
                  )
                ],
              ),
            ),
            Text(creditCards.length.toString()),
            //tarjatas
            Column(
              children: [
                SizedBox(
                  height: 190,
                  child: PageView.builder(
                      controller: _pageController,
                      itemCount: creditCards.length,
                      itemBuilder: (context, index) {
                        final card = creditCards[index];
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
                                      cardHolderFullName:
                                          card.cardHolderFullName,
                                      cardNumber: card.cardNumber,
                                      validThru: card.validThru,
                                      cardType: card.cardType,
                                      cvv: card.cvv,
                                      color: card.color,
                                      isFavorite: card.isFavorite,
                                    )),
                              );
                            });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: SmoothPageIndicatorWidget(
                    pageController: _pageController,
                    totalCounts: creditCards.length,
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
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonSecondVersionIcon(
                    function: () {
                      debugPrint("La longitud");
                    },
                    text: "Eliminar",
                    icon: Icons.delete_rounded,
                    iconAlignment: IconAlignment.end),
                ButtonSecondVersionIcon(
                    function: () {
                      Navigator.pushNamed(context, Routes.CARDPAGE);
                    },
                    text: "Nueva",
                    icon: Icons.add_card_rounded,
                    iconAlignment: IconAlignment.start),
              ],
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FloatingButtonNavBarQr(),
      bottomNavigationBar: const BottomMainAppBar(),
    );
  }
}
