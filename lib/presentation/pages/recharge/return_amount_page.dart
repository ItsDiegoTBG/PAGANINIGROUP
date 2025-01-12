import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/credits_cards_view.dart';
import 'package:paganini/presentation/widgets/floating_button_paganini.dart';
import 'package:paganini/presentation/widgets/smooth_page_indicator.dart';
import 'package:paganini/presentation/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReturnAmountPage extends StatefulWidget {
  const ReturnAmountPage({super.key});

  @override
  State<ReturnAmountPage> createState() => _ReturnAmountPageState();
}

class _ReturnAmountPageState extends State<ReturnAmountPage> {
  late PageController _pageController;
  final TextEditingController returnAmountController = TextEditingController();
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
  String selectedType = "count";
  bool _isEnabledTextFormField = true;
  @override
  Widget build(BuildContext context) {
    final saldoProviderWatch = context.watch<SaldoProvider>();
    final saldoProviderRead = context.read<SaldoProvider>();
    final creditCardProviderWatch = context.watch<CreditCardProvider>();
    final creditCards = creditCardProviderWatch.creditCards;
    final userId = context.read<UserProvider>().currentUser?.id;
    final color = Theme.of(context).primaryColor;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const ContentAppBar(),
      ),
      body: _isLoading
          ? const _ProcessingStep()
          : Center(
              child: Column(
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
                              "\$${saldoProviderRead.saldo}", // Aquí pones el valor que quieres mostrar
                              style: const TextStyle(
                                color: Colors.white, // Color del texto
                                fontSize: 37,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Form(
                        child: TextFormFieldWidget(
                            enabled: _isEnabledTextFormField,
                            controller: returnAmountController,
                            hintText: "Asigne el valor a regresar",
                            textInputType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ingrese el monto';
                              }
                              return null;
                            }),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Todo",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          Checkbox(
                            tristate: false,
                            visualDensity: VisualDensity.compact,
                            checkColor: Colors.white,
                            //fillColor: const WidgetStatePropertyAll(Colors.red),
                            activeColor: Colors.green,
                            hoverColor: AppColors.primaryColor,
                            value: !_isEnabledTextFormField,
                            onChanged: (bool? value) {
                              setState(() {
                                _isEnabledTextFormField =
                                    !_isEnabledTextFormField;
                              });
                            },
                          )
                        ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
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
                            const SizedBox(
                              height: 100,
                            ),
                            const Text(
                              "Registrar una tarjeta ahora",
                              style: TextStyle(fontSize: 20),
                            ),
                            IconButton(
                                style: ButtonStyle(
                                    iconColor: WidgetStateProperty.all(color)),
                                onPressed: () {
                                  Navigator.pushNamed(context, Routes.CARDPAGE);
                                },
                                icon: const Icon(
                                  Icons.app_registration_rounded,
                                  size: 60,
                                ))
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
                  if (creditCards.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (saldoProviderRead.saldo == 0) {
                              debugPrint("El saldo actual es 0");
                              AnimatedSnackBar(
                                duration: const Duration(seconds: 3),
                                builder: ((context) {
                                  return MaterialAnimatedSnackBar(
                                    iconData: Icons.info,
                                    messageText: 'No hay saldo en la cuenta',
                                    type: AnimatedSnackBarType.error,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    backgroundColor: Colors.blue[900]!,
                                    titleTextStyle: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 10,
                                    ),
                                  );
                                }),
                              ).show(context);
                              return;
                            }
                            if (!_isEnabledTextFormField) {
                              setState(() {
                                _isLoading = true; // Mostrar indicador de carga
                              });
                              int selectedIndex = _pageController.page?.round() ?? 0;
                              final selectedCard = creditCards[selectedIndex];
                              final newBalance = selectedCard.balance + saldoProviderRead.saldo;
                              // Operación asíncrona fuera de setState
                              await Future.delayed(const Duration(seconds: 2));
                              creditCardProviderWatch.updateBalance(userId!, selectedIndex, newBalance);
                              saldoProviderWatch.setZero();
                              if (context.mounted) {
                                // Asegurarse de que el contexto siga montado antes de navegar
                                Navigator.pop(context);
                                AnimatedSnackBar(
                                duration: const Duration(seconds: 3),
                                builder: ((context) {
                                  return MaterialAnimatedSnackBar(
                                    iconData: Icons.check,
                                    messageText: 'Accion exitosa',
                                    type: AnimatedSnackBarType.error,
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    backgroundColor: Colors.green[900]!,
                                    titleTextStyle: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 10,
                                    ),
                                  );
                                }),
                              ).show(context);
                              }

                              setState(() {
                                _isLoading =false; // Ocultar indicador de carga
                              });

                              return;
                            }

                            if (returnAmountController.text.isEmpty) {
                              AnimatedSnackBar(
                                duration: const Duration(seconds: 3),
                                builder: ((context) {
                                  return MaterialAnimatedSnackBar(
                                    iconData: Icons.info,
                                    messageText: 'Asigne un monto',
                                    type: AnimatedSnackBarType.error,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    backgroundColor: Colors.blue[900]!,
                                    titleTextStyle: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 10,
                                    ),
                                  );
                                }),
                              ).show(context);
                              return;
                            }

                            final double amountReturn = double.parse(returnAmountController.text);
                            int selectedIndex = _pageController.page?.round() ?? 0;
                            final selectedCard = creditCards[selectedIndex];
                            debugPrint("El monto a regresar es: $amountReturn");
                            if (amountReturn < 0 || amountReturn == 0) {
                              AnimatedSnackBar(
                                duration: const Duration(seconds: 3),
                                builder: ((context) {
                                  return MaterialAnimatedSnackBar(
                                    iconData: Icons.info,
                                    messageText: 'Asigne un monto',
                                    type: AnimatedSnackBarType.error,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    backgroundColor: Colors.blue[900]!,
                                    titleTextStyle: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 10,
                                    ),
                                  );
                                }),
                              ).show(context);
                              return;
                            }

                            if (amountReturn > saldoProviderWatch.saldo) {
                              AnimatedSnackBar(
                                duration: const Duration(seconds: 3),
                                builder: ((context) {
                                  return MaterialAnimatedSnackBar(
                                    iconData: Icons.warning,
                                    messageText: 'El monto excede el saldo',
                                    type: AnimatedSnackBarType.error,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    backgroundColor: Colors.yellow[900]!,
                                    titleTextStyle: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 10,
                                    ),
                                  );
                                }),
                              ).show(context);
                              return;
                            }

                            setState(() {
                              _isLoading = true; // Mostrar indicador de carga
                            });
                            await Future.delayed(const Duration(seconds: 2));

                            saldoProviderWatch.subRecharge(amountReturn);
                            final newBalance =amountReturn + selectedCard.balance;
                            creditCardProviderWatch.updateBalance(userId!, selectedIndex, newBalance);

                            if (context.mounted) {
                              Navigator.pop(context);

                              AnimatedSnackBar(
                                duration: const Duration(seconds: 3),
                                builder: ((context) {
                                  return MaterialAnimatedSnackBar(
                                    iconData: Icons.check,
                                    messageText: 'Operacion realizada con exito',
                                    type: AnimatedSnackBarType.error,
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    backgroundColor: Colors.green[900]!,
                                    titleTextStyle: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 10,
                                    ),
                                  );
                                }),
                              ).show(context);
                            }
                             setState(() {
                                _isLoading =false; // Ocultar indicador de carga
                              });
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
                            'Aceptar',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingButtonPaganini(
          iconData: Icons.arrow_back_rounded,
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}

class _ProcessingStep extends StatelessWidget {
  const _ProcessingStep();

  @override
  Widget build(BuildContext context) {
    return Center(
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
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<double>(
              stream:
                  Stream.periodic(const Duration(milliseconds: 200), (value) {
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
    );
  }
}
