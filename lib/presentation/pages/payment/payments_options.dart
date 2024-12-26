import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/pages/payment/confirm_payments_options_selected.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/payment_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';
import 'package:provider/provider.dart';

class PaymentOptions extends StatefulWidget {
  const PaymentOptions({super.key});

  @override
  State<PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  Map<int, bool> selectedCards = {};

  @override
  Widget build(BuildContext context) {
    final saldo = context.read<SaldoProvider>().saldo;
    final creditCardProviderWatch = context.watch<CreditCardProvider>();
    final creditCards = creditCardProviderWatch.creditCards;
    final myHeight = MediaQuery.of(context).size.height;
    final paymentProviderWatch = context.watch<PaymentProvider>();
    final montoSaldo = paymentProviderWatch.montoSaldo;
    final isSaldoSelected = paymentProviderWatch.isSaldoSelected;
    final selectedCardAmounts = paymentProviderWatch.selectedCardAmounts;

    return Container(
      height: myHeight * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              const Text(
                '¿Como quieres pagar? ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Utilizar mi saldo de Paganini: \$$saldo\USD',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Switch(
                  activeTrackColor: Colors.black,
                  value: isSaldoSelected,
                  onChanged: (value) {
                    paymentProviderWatch.toggleSaldoSelection();
                  },
                ),
              ),
            ],
          ),
          if (isSaldoSelected)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingresa el monto que deseas pagar con tu saldo:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: '\$0.00',
                          ),
                          onChanged: (value) {
                            final montoSaldo = double.tryParse(value) ?? 0.0;
                            paymentProviderWatch.setMontoSaldo(montoSaldo);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const Divider(),
          Expanded(
            child: CustomScrollView(
              
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final card = creditCards[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CreditCardWidget(
                                    supportNfc: false,
                                    balance: card.balance,
                                    width: 100,
                                    cardHolderFullName: card.cardHolderFullName,
                                    cardNumber: card.cardNumber,
                                    validThru: card.validThru,
                                    cardType: card.cardType,
                                    cvv: card.cvv,
                                    color: card.color,
                                    isFavorite: card.isFavorite,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              card.cardHolderFullName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Switch(
                                                activeColor: Colors.white,
                                                activeTrackColor:
                                                    AppColors.primaryColor,
                                                value: selectedCards[index] ??
                                                    false,
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedCards[index] =
                                                        value;
                                                    if (value == true) {
                                                      paymentProviderWatch.selectedCardAmounts.remove(index);
                                                    }
                                                  });
                                                }),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${card.cardType == "credit" ? "Tarjeta de crédito" : "Tarjeta de débito"} ••• ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 100, 99, 99),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (selectedCards[index] == true)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          hintText: '\$0.00',
                                        ),
                                        onChanged: (value) {
                                          final amount =
                                              double.tryParse(value) ?? 0.0;
                                          paymentProviderWatch.setCardAmount(
                                              index, amount);
                                        },
                                      ),
                                    ),
                                    
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    childCount:
                        creditCards.length, // Número de elementos a renderizar
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              paymentProviderWatch.toggleConfirmPaymetOrPaymentSelected();
            },
            child: const Center(
              child: Text(
                "Siguiente",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
