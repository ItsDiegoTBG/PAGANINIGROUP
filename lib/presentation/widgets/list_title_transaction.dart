import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/models/transaction_model.dart';

class ListTitleTransaction extends StatefulWidget {
  final bool? withDescription;
  final TransactionModel transaction;
  final double? paddingRight;

  const ListTitleTransaction({
    super.key,
    required this.transaction,
    this.withDescription = false,
    this.paddingRight = 15,
  });

  @override
  State<ListTitleTransaction> createState() => _ListTitleTransactionState();
}

class _ListTitleTransactionState extends State<ListTitleTransaction> {
  bool _isDescriptionVisible = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.secondaryColor,
        child: Text(widget.transaction.originator[0]),
      ),
      title: Row(
        children: [
          // Nombre del originador
          Text(
            widget.transaction.originator,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          // Botón de flecha pegado al nombre
          if (widget.withDescription! && !widget.transaction.isIncome())
            IconButton(
              icon: const Icon(Icons.arrow_right),
              onPressed: () {
                setState(() {
                  _isDescriptionVisible = !_isDescriptionVisible;
                });
              },
              padding: EdgeInsets.zero, // Elimina el padding del IconButton
              constraints: const BoxConstraints(), // Ajusta las restricciones
            ),
          // Espaciador para empujar el monto al borde derecho
          const Spacer(),
          // Monto alineado a la derecha
          Text(
            widget.transaction.isIncome()
                ? "+\$${widget.transaction.amount}"
                : "-\$${widget.transaction.amount.abs()}",
            style: TextStyle(
              color: widget.transaction.isIncome() ? Colors.green : Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
      subtitle: _isDescriptionVisible
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Métodos de pago:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...widget.transaction.paymentMethods!.map(
                  (paymentMethod) => Text(
                    paymentMethod,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
