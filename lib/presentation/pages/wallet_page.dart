import 'package:flutter/material.dart';
import 'package:paganini/domain/models/card_model.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version_icon.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';
import 'package:paganini/presentation/widgets/smooth_page_indicator.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

List<CreditCardModel> creditCardList = [
  CreditCardModel(
    cardHolderFullName: 'John Doe',
    cardNumber: '1234 5678 9012 3456',
    cardType: 'credit',
    validThru: '12/26',
    color: Colors.blueAccent,
    isFavorite: true,
    cvv: '123',
  ),
  CreditCardModel(
    cardHolderFullName: 'Jane Smith',
    cardNumber: '9876 5432 1098 7654',
    cardType: 'debit',
    validThru: '11/25',
    color: Colors.green,
    isFavorite: false,
    cvv: '456',
  ),
  CreditCardModel(
    cardHolderFullName: 'Alice Johnson',
    cardNumber: '1111 2222 3333 4444',
    cardType: 'giftCard',
    validThru: '10/24',
    color: Colors.purple,
    isFavorite: false,
    cvv: '789',
  ),
  CreditCardModel(
    cardHolderFullName: 'Bob Brown',
    cardNumber: '5555 6666 7777 8888',
    cardType: 'credit',
    validThru: '09/23',
    color: Colors.orange,
    isFavorite: true,
    cvv: '321',
  ),
];

class _WalletPageState extends State<WalletPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: const Column(
                    children: [
                      Padding(
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
                      SizedBox(
                          height:
                              10), // Espacio entre el texto de saldo y el valor
                      Text(
                        '\$688', // Aquí pones el valor que quieres mostrar
                        style: TextStyle(
                            color: Colors.white, // Color del texto
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                )),
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonSecondVersion(text: "Agregar"),
                  SizedBox(
                    width: 10,
                  ),
                  ButtonSecondVersion(text: "Transferir")
                ],
              ),
            ),

            //tarjatas
            SizedBox(
              height: 190,
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: creditCardList.length,
                  itemBuilder: (context, index) {
                    final card = creditCardList[index];
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
                                  cardHolderFullName: card.cardHolderFullName,
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
                totalCounts: creditCardList.length,
                smoothPageEffect: const WormEffect(
                  activeDotColor: AppColors.primaryColor,
                  dotColor: AppColors.secondaryColor,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonSecondVersionIcon(
                    text: "Eliminar",
                    icon: Icons.delete_rounded,
                    iconAlignment: IconAlignment.end),
                ButtonSecondVersionIcon(
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
