import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/domain/usecases/contact_use_case.dart';
import 'package:paganini/helpers/show_animated_snackbar.dart';
import 'package:paganini/presentation/providers/contact_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../data/models/contact_model.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';


class RenameCardDialog extends StatefulWidget {
  final int index;
  const RenameCardDialog(this.index, {super.key});

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
    final userId = context.read<UserProvider>().currentUser?.id;
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
            if (name.isNotEmpty) {
              for (int i = 0; i < creditCards.length; i++) {
              if (creditCards[i] == creditCards[widget.index]){
                final cardIndex = i;
                //creditCardProviderWatch.updateName(userId!, cardIndex, name);
                Provider.of<CreditCardProvider>(context, listen: false).updateName(userId!, cardIndex, name);
              }
            }
            Navigator.pop(context);
            setState(() {
            });
            }
            
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
