import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/datasources/userservice.dart';
import 'package:paganini/data/models/contact_model.dart';
import 'package:paganini/domain/usecases/contact_use_case.dart';
import 'package:paganini/helpers/show_animated_snackbar.dart';
import 'package:paganini/presentation/pages/payment/confirm_payments_options_selected.dart';
import 'package:paganini/presentation/pages/payment/payments_options.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/payment_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
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

   late ContactUseCase contactUseCase;

  @override
  void initState() {
    super.initState();
    contactUseCase = context.read<ContactUseCase>();
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
    final userId = context.read<UserProvider>().currentUser?.id;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const ContentAppBar(),
        automaticallyImplyLeading: false,
      ),
     // backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          firstPart(userService, context, userId ?? "No hay usuario"),
          const SizedBox(
            height: 20,
          ),
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
                    paymentProviderWatch.setTotalAmountPayUser(
                        double.tryParse(pageToUserController.text)!);
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
                              builder: (context, scrollController) =>
                                  SingleChildScrollView(
                                controller: scrollController,
                                child: Consumer<PaymentProvider>(
                                  builder:
                                      (context, paymentProviderWatch, child) {
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

  Column firstPart(
      UserService userService, BuildContext context, String userId) {
    final paymentProviderWatch = context.watch<PaymentProvider>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primaryColor,
            ),
            child: Center(
              child: Text(
                  "Pagar a ${paymentProviderWatch.userPaymentData?.firstname}",style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () async {
                ContactUser contact = ContactUser(
                  name: paymentProviderWatch.userPaymentData?.firstname ?? "",
                  phone: paymentProviderWatch.userPaymentData?.phone ?? "",
                  isRegistered: true,
                );
                contactUseCase.callSaveToFirst(contact);
                ShowAnimatedSnackBar.show(context, "Agregado al contacto", Icons.check, AppColors.greenColors);
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
