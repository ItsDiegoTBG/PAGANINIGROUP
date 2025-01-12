import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/domain/entity/card_credit.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';
import 'package:paganini/presentation/widgets/credits_cards_view.dart';
import 'package:paganini/presentation/widgets/floating_button_paganini.dart';

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
    creditCardProvider.fetchCreditCards(FirebaseAuth.instance.currentUser!.uid);
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
    final userId = context.read<UserProvider>().currentUser?.id;
    final color = Theme.of(context).primaryColor;
    return Scaffold(
  
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const ContentAppBar(),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 300,
                      height: 130,
                      child: Image.asset(
                          "assets/image/paganini_logo_horizontal_negro.png")),
                  const Text(
                    "Procesando",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<double>(
                      stream: Stream.periodic(const Duration(milliseconds: 200),
                          (value) {
                        return (value * 2) / 25;
                      }).takeWhile((value) => value < 100),
                      builder: (context, snapshot) {
                        final progressValue = snapshot.data ?? 0.0;
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 8),
                          child: LinearProgressIndicator(
                            value: progressValue,
                            // minHeight: 100,
                          ),
                        );
                      })
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
                                      fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
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

                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 40),
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
                  if (creditCards.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          const Text("Registrar una nueva tarjeta",
                              style: TextStyle(
                                fontSize: 18,
                              )),
                          IconButton(
                              style: ButtonStyle(iconColor: WidgetStateProperty.all(color)),
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.CARDPAGE);
                              },
                              icon: const Icon(Icons.app_registration_rounded,size: 30,))
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  //tarjetas
                  Column(
                    children: [
                      if (creditCards.isEmpty)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "No tienes tarjetas registradas",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.visible,
                            ),
                            const SizedBox(height: 100,),
                            const Text("Registrar una tarjeta ahora",style: TextStyle(fontSize: 20),),
                            IconButton(
                                style: ButtonStyle(iconColor: WidgetStateProperty.all(color)),
                                onPressed: () {
                                  Navigator.pushNamed(context, Routes.CARDPAGE);
                                },
                                icon:
                                    const Icon(Icons.app_registration_rounded,size: 60,))
                          ],
                        ),
                      if (creditCards.isNotEmpty)
                        CreditCardsView(
                            creditCards: creditCards,
                            pageController: _pageController),
                      if (creditCards.isNotEmpty)
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
                  if(creditCards.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          debugPrint(
                              "Pantalla de cancelar recargar para volver atras");
                          Navigator.pop(context);
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
                          debugPrint("Recargar saldo");
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
                                  userId!,
                                  selectedIndex,
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
                                  context, Routes.NAVIGATIONPAGE);
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
                                  messageText:
                                      'Saldo insuficiente en la tarjeta',
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
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingButtonPaganini(
        onPressed: () {
          if (creditCards.isNotEmpty) {
            Navigator.pop(context);
          }
          else {
            Navigator.pushNamed(context, Routes.HOME);
          }
        },
        iconData: Icons.arrow_back_rounded,
      ),
    );
  }
}

