import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:provider/provider.dart';

class ConfirmPaymentPage extends StatelessWidget {
  final Map<int, double> selectedCardAmounts;
  final double montoSaldo;
  final bool isSaldoSelected;

  const ConfirmPaymentPage({
    super.key,
    required this.selectedCardAmounts,
    required this.montoSaldo,
    required this.isSaldoSelected,
  });

  @override
  Widget build(BuildContext context) {
    final myHeight = MediaQuery.of(context).size.height;
    final saldo = context.read<SaldoProvider>().saldo;
    final creditCardProviderWatch = context.watch<CreditCardProvider>();
    final creditCards = creditCardProviderWatch.creditCards;

    final totalAmount = montoSaldo +
        selectedCardAmounts.values.fold(0.0, (sum, amount) => sum + amount);

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
                const Text(
                  "Resumen del Pago",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 10),
            if (isSaldoSelected)
              ListTile(
                title: const Text("Saldo de la cuenta"),
                subtitle: Text("Monto seleccionado: \$$montoSaldo"),
                leading: const Icon(Icons.account_balance_wallet),
              ),
            ...selectedCardAmounts.entries.map((entry) {
              return ListTile(
                title: Text("Tarjeta ${entry.key + 1}"),
                subtitle: Text("Monto seleccionado: \$$entry.value"),
                leading: const Icon(Icons.credit_card),
              );
            }).toList(),
            const Divider(),
            ListTile(
              title: const Text(
                "Total a pagar",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "\$$totalAmount",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
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
          ],
        ),
      ),
    );
  }
}
