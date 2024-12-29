import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/datasources/userservice.dart';
import 'package:paganini/presentation/pages/payment/confirm_payments_options_selected.dart';
import 'package:paganini/presentation/pages/payment/payments_options.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/payment_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';

import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final String? dataId;

  const PaymentPage({super.key, required this.dataId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController pageToUserController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  List<TextEditingController> saldoControllers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final creditCardProviderWatch = context.read<CreditCardProvider>();
      final creditCards = creditCardProviderWatch.creditCards;
      debugPrint(
          "Las tarjeta de credito que trajo son : ${creditCards.length}");
      if (creditCards.isNotEmpty) {
        setState(() {
          saldoControllers = List.generate(creditCards.length, (index) {
            return TextEditingController();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    // Limpia los controladores al final
    for (var controller in saldoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    final saldo = context.read<SaldoProvider>().saldo;
    final creditCardProviderWatch = context.watch<CreditCardProvider>();
    final creditCards = creditCardProviderWatch.creditCards;
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    final paymentProviderWatch = context.watch<PaymentProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const ContentAppBar(),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          firstPart(userService, context),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
            ),
            child: TextFormField(
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 60, color: Colors.black),
              textAlign: TextAlign.end,
              inputFormatters: const [
                // LengthLimitingTextInputFormatter(8),
              ],
              controller: pageToUserController,
              decoration: const InputDecoration(
                prefixIconColor: AppColors.primaryColor,
                prefixIcon: Icon(
                  Icons.attach_money_outlined,
                  size: 70,
                ),
                hintText: "0.00",
                hintTextDirection: TextDirection.ltr,
                hintStyle: TextStyle(fontSize: 60, color: Colors.grey),
              ),
              onChanged: (value) {
                //algo
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un monto';
                }

                // Convertir el valor ingresado a número y eliminar posibles comas
                double? enteredValue =
                    double.tryParse(value.replaceAll(",", ""));

                if (enteredValue == null || enteredValue <= 0) {
                  return 'Por favor ingresa un monto válido';
                }

                // Validación del valor máximo (15000)
                if (enteredValue > 15000) {
                  return 'El monto máximo a transferir es 15000';
                }

                return null;
              },
            ),
          ),
          const SizedBox(
            height: 45,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Añadir un mensaje',
                hintText: 'E.j., Pago de la compra',
                border: OutlineInputBorder(),
              ),
              maxLength: 100, // Límite de caracteres opcional
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          pageToUserController.text.isNotEmpty
              ? ButtonSecondVersion(
                  text: "Siguiente",
                  function: () {
                    paymentProviderWatch.setTotalAmountPayUser(double.tryParse(pageToUserController.text)!);
                    paymentProviderWatch.setNoteUserToPay(noteController.text);
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      isScrollControlled: true,
                      builder: (context) => DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.7,
                        minChildSize: 0.32,
                        maxChildSize: 0.9,
                        builder: (context, scrollController) => SingleChildScrollView(
                          controller: scrollController,
                          child: Consumer<PaymentProvider>(
                            builder: (context, paymentProviderWatch, child) {
                              return paymentProviderWatch
                                  .isConfirmPaymetOrPaymentSelected
                                  ? const ConfirmPaymentPage()
                                  : const PaymentOptions();
                            },
                          ),
                        ),
                      ));
                  })
              : const Text("Asigna un monto para poder avanzar")
        ],
      ),

    );
  }

  Row firstPart(UserService userService, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primaryColor,
            ),
            child: widget.dataId != null
                ? Center(
                    child: FutureBuilder<Map<String, dynamic>?>(
                      future: userService.fetchUserById(widget.dataId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Muestra un cargador mientras se obtienen los datos
                        } else if (snapshot.hasError) {
                          return const Text(
                              'Error al cargar datos'); // Muestra un mensaje de error
                        } else if (snapshot.hasData) {
                          final userData = snapshot.data!;

                          return Text(
                            "Pagar a ${userData['firstname']}", // Muestra el nombre del usuario
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          );
                        } else {
                          return const Text(
                              'Usuario no encontrado'); // Si el usuario no existe
                        }
                      },
                    ),
                  )
                : const Text(
                    'ID de usuario no proporcionado',
                    style: TextStyle(color: Colors.black),
                  ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Obtén el estado del proveedor sin escucharlo
                final creditCardProviderWatch =
                    context.read<CreditCardProvider>();
                final creditCards = creditCardProviderWatch.creditCards;
                double totalPago = 0.0;

                // Accede a los valores de saldo sin reconstruir el widget
                final saldoProviderRead = context.read<SaldoProvider>();
                final saldo = saldoProviderRead.saldo;

                // Convierte el saldo ingresado a double
                double valueSaldo =
                    double.tryParse(pageToUserController.text) ?? 0.0;

                if (valueSaldo >= 0.0) {
                  if (valueSaldo <= saldo) {
                    // Realiza el descuento en el saldo
                    saldoProviderRead.subRecharge(valueSaldo);
                    totalPago += valueSaldo;
                  } else {
                    AnimatedSnackBar(
                      duration: const Duration(seconds: 3),
                      builder: ((context) {
                        return const MaterialAnimatedSnackBar(
                          iconData: Icons.check,
                          messageText: 'Saldo Insuficiente',
                          type: AnimatedSnackBarType.warning,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          backgroundColor: Color.fromARGB(255, 222, 53, 48),
                          titleTextStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 10,
                          ),
                        );
                      }),
                    ).show(context);
                    return;
                  }
                }

                // Verifica cada tarjeta y el saldo ingresado para cada una
                for (int i = 0; i < creditCards.length; i++) {
                  double saldoPago =
                      double.tryParse(saldoControllers[i].text) ?? 0.0;

                  if (saldoPago > 0) {
                    double tarjetaSaldo = creditCards[i].balance;

                    if (tarjetaSaldo >= saldoPago) {
                      // Realiza el descuento en la tarjeta y actualiza el saldo
                      double nuevoSaldo = tarjetaSaldo - saldoPago;
                      await creditCardProviderWatch.updateBalance(
                          creditCards[i].id, nuevoSaldo);

                      totalPago += saldoPago;
                    } else {
                      AnimatedSnackBar(
                        duration: const Duration(seconds: 3),
                        builder: ((context) {
                          return MaterialAnimatedSnackBar(
                            iconData: Icons.check,
                            messageText:
                                'Saldo Insuficiente en ${creditCards[i].cardHolderFullName}',
                            type: AnimatedSnackBarType.info,
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(20)),
                            backgroundColor:
                                const Color.fromARGB(255, 59, 84, 244),
                            titleTextStyle: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 10,
                            ),
                          );
                        }),
                      ).show(context);
                      return;
                    }
                  }
                }

                // Verifica si se realizaron pagos
                if (totalPago > 0) {
                  AnimatedSnackBar(
                    duration: const Duration(seconds: 3),
                    builder: ((context) {
                      return MaterialAnimatedSnackBar(
                        iconData: Icons.check,
                        messageText:
                            'Pago realizado con exito! Total \$${totalPago.toStringAsFixed(2)}',
                        type: AnimatedSnackBarType.info,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        backgroundColor: const Color.fromARGB(255, 30, 219, 17),
                        titleTextStyle: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 10,
                        ),
                      );
                    }),
                  ).show(context);

                  Future.delayed(const Duration(seconds: 2), () {
                    // Este código se ejecutará después del retraso de 2 segundos
                    Navigator.pushNamed(context, Routes.HOME);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: AppColors.secondaryColor,
                minimumSize: const Size(133, 50),
              ),
              child: const Text(
                'Agregar',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            ElevatedButton(
              onPressed: () {
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
          ],
        )
      ],
    );
  }
}
