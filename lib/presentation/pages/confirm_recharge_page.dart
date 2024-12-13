import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';
import 'package:paganini/presentation/widgets/smooth_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ConfirmRechargePage extends StatefulWidget {
  final String? valueRecharge;
  const ConfirmRechargePage({super.key, this.valueRecharge = "0"});

  @override
  State<ConfirmRechargePage> createState() => _ConfirmRechargePageState();
}

class _ConfirmRechargePageState extends State<ConfirmRechargePage> {
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

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final saldoProviderWatch = context.watch<SaldoProvider>();
    final saldoProviderRead = context.read<SaldoProvider>();
    final creditCardProviderWatch = context.watch<CreditCardProvider>();
    final creditCards = creditCardProviderWatch.creditCards;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const ContentAppBar(),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Verificando...",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Container(
                        height: 150,
                        width: 360,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 0, top: 8),
                                  child: Text(
                                    'Recarga',
                                    style: TextStyle(
                                      color: Colors.white, // Color del texto
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Espacio entre el texto de saldo y el valor
                                Text(
                                  "\$${widget.valueRecharge}", // Aquí pones el valor que quieres mostrar
                                  style: const TextStyle(
                                      color: Colors.white, // Color del texto
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Saldo Actual : ',
                                    style: TextStyle(
                                      color: Colors.white, // Color del texto
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "\$${saldoProviderRead.saldo}", // Aquí pones el valor que quieres mostrar
                                  style: const TextStyle(
                                    color: Colors.white, // Color del texto
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),

                  //Text(creditCards.length.toString()),
                  creditCards.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 25),
                          child: Text(
                            "No tiene tarjetas registradas",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.visible,
                          ),
                        )
                      : const Text(""),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Elija su tarjeta:",
                          style: TextStyle(
                              fontSize: 22,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  //tarjetas
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
                                    if (_pageController
                                        .position.haveDimensions) {
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
                                          cardHolderFullName:
                                              card.cardHolderFullName,
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SmoothPageIndicatorWidget(
                          pageController: _pageController,
                          totalCounts:
                              creditCards.isEmpty ? 1 : creditCards.length,
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
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Routes.HOME);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Ajusta el valor para más o menos curvatura
                          ),
                          backgroundColor: Colors.red[300],
                          minimumSize: const Size(120, 50),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          var myRecharge = double.parse(widget.valueRecharge!);
                          int selectedIndex =
                              _pageController.page?.round() ?? 0;
                          final selectedCard = creditCards[selectedIndex];

                          // Verifica que la tarjeta seleccionada tenga suficiente saldo
                          if (selectedCard.balance >= myRecharge) {
                            setState(() {
                              _isLoading = true; // Mostrar indicador de carga
                            });

                            // Simula un retraso para la operación de recarga
                            await Future.delayed(const Duration(seconds: 2),
                                () {
                              // Resta el saldo de la tarjeta seleccionada
                              creditCardProviderWatch.updateBalance(
                                  selectedCard.id,
                                  selectedCard.balance - myRecharge);

                              // Agrega la recarga al saldo general
                              saldoProviderWatch.addRecharge(myRecharge);
                            });

                            //setState(() {
                            //  _isLoading = false; // Ocultar indicador de carga
                            // });

                            // Navega de vuelta a la página de inicio
                            if (context.mounted) {
                              Navigator.pushReplacementNamed(
                                  context, Routes.HOME);
                            }
                          } else {
                            // Muestra un mensaje si no hay saldo suficiente
                            debugPrint(
                                "Saldo insuficiente en la tarjeta seleccionada");

                            AnimatedSnackBar(
                              duration: const Duration(seconds: 3),
                              builder: ((context) {
                                return const MaterialAnimatedSnackBar(
                                  iconData: Icons.check,
                                  messageText: 'Saldo insuficiente en la tarjeta',
                                  type: AnimatedSnackBarType.error,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  backgroundColor:
                                      Color.fromARGB(255, 213, 55, 84),
                                  titleTextStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 10,
                                  ),
                                );
                              }),
                            ).show(context);
                          }

                          const Duration(seconds: 1);
                          // ignore: use_build_context_synchronously
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Ajusta el valor para más o menos curvatura
                          ),
                          backgroundColor: Colors.green[300],
                          minimumSize: const Size(120, 50),
                        ),
                        child: const Text(
                          'Agregar',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
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
