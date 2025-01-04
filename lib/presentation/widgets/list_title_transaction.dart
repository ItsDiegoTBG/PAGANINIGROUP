import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/models/transaction_model.dart';

class ListTitleTransaction extends StatefulWidget {
  final bool? withDescription;
  const ListTitleTransaction({
    super.key,
    required this.transaction,
    this.withDescription = false,
  });

  final TransactionModel transaction;

  @override
  State<ListTitleTransaction> createState() => _ListTitleTransactionState();
}

class _ListTitleTransactionState extends State<ListTitleTransaction> {
  bool _isDescriptionVisible = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        // Información principal
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.transaction.originator,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                widget.transaction.date,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        // Monto
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.transaction.isIncome()
                    ? Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                          "+\$${widget.transaction.amount}",
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                    )
                    : Text(
                        "-\$${widget.transaction.amount.abs()}",
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
              ],
            ),
            if (widget.withDescription! && !widget.transaction.isIncome())
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: () {
                      setState(() {
                        // Cambiar el estado para mostrar u ocultar la descripción
                        _isDescriptionVisible = !_isDescriptionVisible;
                      });
                    }),
              ),
          ],
        ),

        // Icono
      ]),
      leading: CircleAvatar(
        backgroundColor: AppColors.secondaryColor,
        child: Text(widget.transaction.originator[0]),
      ),
      subtitle: _isDescriptionVisible
          ?  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Métodos de pago:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...widget.transaction.paymentMethods!.map((paymentMethod) {
                  return Text(
                    paymentMethod,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  );
                })
                
              ],
            )
          : null,
    );
  }
}
