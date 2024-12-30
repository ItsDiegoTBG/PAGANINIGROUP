import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paganini/core/device/qr_code_scanner.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/presentation/pages/payment/payment_page.dart';
import 'package:paganini/presentation/pages/recharge_page.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';

import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/widgets/floating_button_paganini.dart';
import 'package:provider/provider.dart';

import '../widgets/credit_card_ui.dart';
//import 'package:paganini/core/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    final creditCardProvider =
        Provider.of<CreditCardProvider>(context, listen: false);
    creditCardProvider.fetchCreditCards();
  }

  String? _result;
  void setResult(String result) {
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    final saldoProviderWatch = context.watch<SaldoProvider>();
    //final saldoProviderRead = context.read<SaldoProvider>();

    final userProviderWatch = context.watch<UserProvider>();
    final creditCardProviderWatch = context.watch<CreditCardProvider>();

    // Obtenemos la lista de tarjetas actualizada directamente del provider
    final creditCards = creditCardProviderWatch.creditCards;
    // theme
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
        body: Column(
          children: [
            Container(
              height: 120,
              width: 360,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: themeProvider.isDarkMode ? Colors.white : AppColors.primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Saldo",
                      style: TextStyle(
                          color: themeProvider.isDarkMode ? Colors.black :Colors.white,
                          fontSize: 33,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "\$${saldoProviderWatch.saldo}",
                            style:TextStyle(
                               color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                              fontSize: 37,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors
                                .secondaryColor, // Cambia el color del fondo
                            borderRadius: BorderRadius.circular(
                                30), // Agrega bordes redondeados
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add,
                                color: AppColors
                                    .primaryColor), // Cambia el color del icono
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.RECHARGE);
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
                height: 200,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: creditCards.isNotEmpty
                        ? creditCards.length > 1
                            ? Swiper(
                                itemWidth: 400,
                                itemHeight: 190,
                                loop: true,
                                duration: 500,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final card = creditCards[index];
                                  return CreditCardWidget(
                                    balance: card.balance,
                                    cardHolderFullName: card.cardHolderFullName,
                                    cardNumber: card.cardNumber,
                                    validThru: card.validThru,
                                    cardType: card.cardType,
                                    cvv: card.cvv,
                                    color: card.color,
                                    isFavorite: card.isFavorite,
                                  );
                                },
                                itemCount: creditCards.length,
                                layout: SwiperLayout.TINDER,
                              )
                            : CreditCardWidget(
                                balance: creditCards[0].balance,
                                cardHolderFullName:
                                    creditCards[0].cardHolderFullName,
                                cardNumber: creditCards[0].cardNumber,
                                validThru: creditCards[0].validThru,
                                cardType: creditCards[0].cardType,
                                cvv: creditCards[0].cvv,
                                color: creditCards[0].color,
                                isFavorite: creditCards[0].isFavorite,
                              )
                        : Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Aun no tienes una tarjeta registrada",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black)),
                              const Text("Registra una ahora",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.primaryColor)),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      color: AppColors
                                          .primaryColor, // Cambia el color del fondo
                                      borderRadius: BorderRadius.circular(
                                          30)), // Agrega bordes redondeados

                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, Routes.CARDPAGE);
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.arrowRightFromBracket,
                                        size: 30,
                                      )))
                            ],
                          )),
                  ),
                )),
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 22, right: 8, bottom: 2),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Acciones Rápidas",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Text(
                "Inicio de cuenta con ${userProviderWatch.user?.email ?? 'usuario no disponible'}"),
            const Text(
                "Reference site about Lorem Ipsum, giving information on its origins, as well as a random Lipsum generator."),
            const Padding(
              padding: EdgeInsets.only(top: 25, left: 22, right: 8, bottom: 0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Movimientos",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            const Text(
                "Reference site about Lorem Ipsum, giving information on its origins, as well as a random Lipsum generator."),
            const Text(
                "Reference site about Lorem Ipsum, giving information on its origins, as well as a random Lipsum generator."),
            const Text(
                "Reference site about Lorem Ipsum, giving information on its origins, as well as a random Lipsum generator."),
          ],
        ),
        floatingActionButton: FloatingButtonPaganini(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QrCodeScanner(setResult: setResult),
              ),
            );
          },
          iconData: Icons.qr_code_scanner_rounded,
        ));
  }
}
