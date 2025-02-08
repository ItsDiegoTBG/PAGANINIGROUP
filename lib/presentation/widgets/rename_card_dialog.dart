import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/domain/usecases/contact_use_case.dart';
import 'package:paganini/helpers/show_animated_snackbar.dart';
import 'package:paganini/presentation/providers/contact_provider.dart';
import 'package:provider/provider.dart';
import '../../data/models/contact_model.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';


class RenameCardDialog extends StatefulWidget {
  const RenameCardDialog({super.key});

  @override
  State<RenameCardDialog> createState() => _RenameCardDialogState();
}

class _RenameCardDialogState extends State<RenameCardDialog> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final creditCardProvider =
        Provider.of<CreditCardProvider>(context, listen: false);
    creditCardProvider.fetchCreditCards(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final creditCardProviderWatch = context.watch<CreditCardProvider>();
    final creditCards = creditCardProviderWatch.creditCards;
    return AlertDialog(
      title: const Text("Cambiar nombre de tarjeta"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Nombre"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
          ),
          onPressed: () async {
            final name = nameController.text.trim();
            // Validar que el usuario no exista en contactos
          },
          child: const Text(
            "Guardar",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
