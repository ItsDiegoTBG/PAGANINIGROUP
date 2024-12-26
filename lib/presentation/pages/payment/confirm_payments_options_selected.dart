import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/payment_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:provider/provider.dart';

class ConfirmPaymentPage extends StatelessWidget {
  const ConfirmPaymentPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final myHeight = MediaQuery.of(context).size.height;
    final saldo = context.read<SaldoProvider>().saldo;
    final creditCardProviderWatch = context.watch<CreditCardProvider>();
    final creditCards = creditCardProviderWatch.creditCards;
    final paymentProvider = context.watch<PaymentProvider>();
    final montoSaldo = paymentProvider.montoSaldo;
    final selectedCardAmounts = paymentProvider.selectedCardAmounts;
    final isSaldoSelected = paymentProvider.isSaldoSelected;
    final noteUserToPay = paymentProvider.noteUserToPay;

    final totalAmount = montoSaldo + selectedCardAmounts.values.fold(0.0, (sum, amount) => sum + amount);

    return Container(
      height: myHeight * 0.8,
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    paymentProvider.toggleConfirmPaymetOrPaymentSelected();
                    paymentProvider.clearSelection();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const Text(
                  "Resumen del Pago",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      paymentProvider.toggleConfirmPaymetOrPaymentSelected();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 10),
            if (isSaldoSelected)
              ListTile(
                title: const Text("Saldo de la cuenta"),
                subtitle: Text("Monto seleccionado: \$$montoSaldo"),
                leading: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.black,
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
            const Divider(),
            noteUserToPay.isNotEmpty ? 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("Nota del usuario : $noteUserToPay", style: const  TextStyle(fontSize: 16, fontWeight: FontWeight.w600,fontStyle: FontStyle.italic),),
            ) : const SizedBox(),
            ListTile(
              title: const Text(
                "Suma total de tus opciones de pagos ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              title: Text(
                "Costo total a pagar a ${paymentProvider.nameUserToPay}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            const Spacer(),
            Align(
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
                  for (int i = 0; i < selectedCardAmounts.length; i++) {
                    debugPrint(
                        "El saldo de la tarjeta $i es: ${creditCards[i].balance} y el nombre es ${creditCards[i].cardHolderFullName}");
                  }
                },
                
                child: const Center(
                  child: Text(
                    "Confirmar Pago",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
