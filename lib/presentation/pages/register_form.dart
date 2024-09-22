import 'package:flutter/material.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';
import 'package:paganini/presentation/widgets/textfile_form.dart';
import 'package:paganini/utils/colors.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Nombre", style: TextStyle(fontSize: 16)),
        const TextFieldForm(
          hintText: 'Ingresa tu nombre',
        ),
        const SizedBox(height: 20),
        const Text("Email", style: TextStyle(fontSize: 16)),
        const TextFieldForm(
          hintText: 'Ingresa tu email',
        ),
        const SizedBox(height: 20),
        const Text("Contraseña", style: TextStyle(fontSize: 16)),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Crea una contraseña',
              suffixIcon: Icon(Icons.visibility)),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                child:
                    ButtonWithoutIcon(text: "Crear Usuario", onPressed: () {})),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(0),
                  backgroundColor: AppColors.primaryColor),
              onPressed: () {
                // Configuración
              },
              child: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    );
  }
}
