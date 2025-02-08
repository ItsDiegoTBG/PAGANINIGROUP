import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/helpers/show_animated_snackbar.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SignOutDialog extends StatefulWidget {
  const SignOutDialog({super.key});

  @override
  State<SignOutDialog> createState() => _SignOutDialogState();
}

class _SignOutDialogState extends State<SignOutDialog> {

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
