import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/helpers/show_animated_snackbar.dart';
import 'package:paganini/presentation/pages/navigation_page.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/payment_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ConfirmPaymentPage extends StatelessWidget {
  const ConfirmPaymentPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final myHeight = MediaQuery.of(context).size.height;
    final saldo = context.read<SaldoProvider>().saldo;
    final saldoProviderWatch = context.watch<SaldoProvider>();
    final creditCardProviderWatch = context.watch<CreditCardProvider>();
    final creditCards = creditCardProviderWatch.creditCards;
    final paymentProvider = context.watch<PaymentProvider>();
    final montoSaldo = paymentProvider.montoSaldo;
    final selectedCardAmounts = paymentProvider.selectedCardAmounts;
    final isSaldoSelected = paymentProvider.isSaldoSelected;
    final noteUserToPay = paymentProvider.noteUserToPay;
    final userId = context.read<UserProvider>().currentUser?.id;
    final isOnlySaldoSelected = paymentProvider.isOnlySaldoSelected;
    final totalPlayerAmount = paymentProvider.totalAmountPayUser;
    final totalAmount = montoSaldo +
        selectedCardAmounts.values.fold(0.0, (sum, amount) => sum + amount);
    final userPaymentEntity = paymentProvider.userPaymentData;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => {
        if (didPop)
          {
            paymentProvider.toggleConfirmPaymetOrPaymentSelected(),
            paymentProvider.clearSelection(),
          }
      },
      child: Container(
        height: myHeight * 0.8,
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -10,
                child: Container(
                  width: 60,
                  height: 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          paymentProvider
                              .toggleConfirmPaymetOrPaymentSelected();
                          paymentProvider.clearSelection();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Text(
                        "Resumen del Pago",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            paymentProvider
                                .toggleConfirmPaymetOrPaymentSelected();
                            paymentProvider.clearSelection();
                            paymentProvider.clearTotalAmountPayUser();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (isSaldoSelected)
                    selectedCardAmounts.isNotEmpty
                        ? ListTile(
                            title: const Text("Saldo de la cuenta"),
                            subtitle: Text("Monto seleccionado: \$$montoSaldo"),
                            leading: const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.black,
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Se usara el saldo de la aplicacion",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                  ...selectedCardAmounts.entries.map((entry) {
                    final cardIndex = entry.key;
                    final cardAmount = entry.value;
                    final card = creditCards[cardIndex];

                    return ListTile(
                      title: Text(
                          "Tarjeta ${entry.key + 1} : ${card.cardHolderFullName}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Monto seleccionado: \$$cardAmount"),
                          Text(
                            '${card.cardType == "credit" ? "Tarjeta de crédito" : "Tarjeta de débito"} ••• ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 100, 99, 99),
                            ),
                          ),
                        ],
                      ),
                      leading: const Icon(
                        Icons.credit_card,
                        color: AppColors.primaryColor,
                      ),
                    );
                  }),
                  if (isOnlySaldoSelected == false) const Divider(),
                  noteUserToPay.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Nota del usuario : $noteUserToPay",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      : const SizedBox(),
                  if (isOnlySaldoSelected == false)
                    ListTile(
                      title: const Text(
                        "Suma total de tus opciones de pagos ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        "\$$totalAmount",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      "Costo total a pagar :",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      "\$${paymentProvider.totalAmountPayUser}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  //const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            debugPrint("El total es $montoSaldo");
                            debugPrint(
                                "El saldo es: $saldo, lo que el usuario escogio  es: $montoSaldo y es  verdadero o falso $isSaldoSelected");
                            debugPrint(
                                "Los montos de las tarjetas son: $selectedCardAmounts");
                            debugPrint(
                                "Todas las tarjetas: ${creditCards.length} $creditCards");

                            for (int i = 0; i < creditCards.length; i++) {
                              debugPrint(
                                  "Tarjeta $i: ${creditCards[i].balance} , y el id es: ${creditCards[i].id}");
                            }

                            /*OK open youtube please
                            1.verificamos que la suma total de sus opcion de pago sea igual al total que paga el usuario
                            2.si elijio pagar con saldo, verificamos que el monto del saldo sea igual o menor al monto saldo que tiene en la cuenta y le restamos el monto que elijio del saldo al saldo de la cuenta                     
                            3.si elijio las tarjetas, verificamos que el motno de cada tarjeta sea igual o menor al monto de cada tarjeta y se la restamos 
                            4.dejar los atributos del provider limpio para realizar otro paog
                          */
                            if (isSaldoSelected == true && saldo <= 0.0) {
                              ShowAnimatedSnackBar.show(
                                  context,
                                  "No tiene saldo en la cuenta",
                                  Icons.warning,
                                  AppColors.yellowColors);
                              return;
                            }
                            if (isOnlySaldoSelected == true &&
                                selectedCardAmounts.isEmpty) {
                              debugPrint("Entra al onluSelected");
                              if (saldo < totalPlayerAmount) {
                                Navigator.pop(context);

                                ShowAnimatedSnackBar.show(
                                    context,
                                    "No tienes saldo suficiente",
                                    Icons.error,
                                    AppColors.redColors);
                                return;
                              } else {
                                debugPrint("Solo saldo seleccionado");
                                debugPrint(
                                    "Solo seleciono el saldo como true ose onlysaldoselected");
                                debugPrint(
                                    "EL saldo es $saldo y el total a pagar es $totalAmount");
                                debugPrint(
                                    "EL tatal a pagat es   $paymentProvider.totalAmountPayUser");
                                saldoProviderWatch
                                    .subRecharge(totalPlayerAmount);
                                paymentProvider.updateUserPaymentSaldo(
                                    userPaymentEntity!, totalPlayerAmount);

                                paymentProvider.clearTotalAmountPayUser();
                                paymentProvider
                                    .setTotalAmountPayUser(totalAmount);
                                paymentProvider.clearSelection();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NavigationPage()),
                                    (Route<dynamic> route) => false);

                                ShowAnimatedSnackBar.show(
                                    context,
                                    "El pago se realizo con exito",
                                    Icons.check,
                                    AppColors.greenColors);
                                return;
                              }
                            }

                            //1
                            if (totalAmount !=
                                paymentProvider.totalAmountPayUser) {
                              ShowAnimatedSnackBar.show(
                                  context,
                                  "El total de tus opciones de pago no cumple con el total que paga al usuario",
                                  Icons.error,
                                  AppColors.redColors);
                              return;
                            }
                            //2
                            if (montoSaldo > saldo) {
                              ShowAnimatedSnackBar.show(
                                  context,
                                  "El monto de Saldo es mayor al que tiene en la cuenta",
                                  Icons.info,
                                  AppColors.blueColors);
                              return;
                            } else {
                              saldoProviderWatch.subRecharge(montoSaldo);
                            }

                            //3 por cada tarjeta
                            for (int cardIndex in selectedCardAmounts.keys) {
                              debugPrint("Tarjeta $cardIndex");
                              // Verifica si el monto seleccionado es nulo
                              if (selectedCardAmounts[cardIndex] == null) {
                                continue;
                              }

                              // Obtén el monto seleccionado
                              double selectedAmount =
                                  selectedCardAmounts[cardIndex]!;
                              debugPrint(
                                  "El monto de la tarjeta $cardIndex es: $selectedAmount");
                              // Verifica si el monto seleccionado es mayor que el saldo de la tarjeta
                              if (selectedAmount >
                                  creditCards[cardIndex].balance) {
                                ShowAnimatedSnackBar.show(
                                    context,
                                    "El monto de la tarjeta ${creditCards[cardIndex].cardHolderFullName} es mayor al que tiene en la tarjeta",
                                    Icons.info,
                                    AppColors.blueColors);
                                return;
                              }

                              // Calcula el nuevo saldo
                              final newBalance =
                                  creditCards[cardIndex].balance -
                                      selectedAmount;
                              creditCardProviderWatch.updateBalance(
                                  userId!, cardIndex, newBalance);
                              debugPrint(
                                  "El nuevo saldo de la tarjeta $cardIndex es: $newBalance");
                            }
                            //4

                            paymentProvider.clearTotalAmountPayUser();
                            saldoProviderWatch.subRecharge(totalAmount);
                            paymentProvider.updateUserPaymentSaldo(
                                userPaymentEntity!, totalPlayerAmount);
                            paymentProvider.setTotalAmountPayUser(totalAmount);
                            paymentProvider.clearSelection();
                            //este mensaje es para indicar que se ha realizado un pago correcto

                            ShowAnimatedSnackBar.show(
                                context,
                                "El pago se ha realizado con exito",
                                Icons.check,
                                Colors.green);
                            Navigator.pop(context);
                            Navigator.pushNamed(context, Routes.NAVIGATIONPAGE);
                          },
                          child: const Center(
                            child: Text(
                              "Confirmar Pago",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
