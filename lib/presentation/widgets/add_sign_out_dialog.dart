import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/helpers/show_animated_snackbar.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddSignOutDialog extends StatefulWidget {
  const AddSignOutDialog({super.key});

  @override
  State<AddSignOutDialog> createState() => _AddSignOutDialogState();
}

class _AddSignOutDialogState extends State<AddSignOutDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return AlertDialog(
      title: const Text("¿Desea cerrar su sesión?"),
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
            Navigator.pop(context, true);
          },
          child: const Text(
            "Salir",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
