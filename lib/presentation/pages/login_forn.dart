import 'package:flutter/material.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';
import 'package:paganini/presentation/widgets/textfile_form.dart';
import 'package:paganini/utils/colors.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Usuario", style: TextStyle(fontSize: 16)),
        const TextFieldForm( hintText: "Ingresa tu usuario",),
        const SizedBox(height: 20),
        const Text("Contraseña", style: TextStyle(fontSize: 16)),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Ingresa tu contraseña',
            suffixIcon: Icon(Icons.visibility),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
             Expanded(
              child: ButtonWithoutIcon(text: "Iniciar Sesion",onPressed: (){
                Navigator.pushReplacementNamed(context, "home_page");
              },),
            ),
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
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text("Olvidaste la Clave?",
                style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.grey,
                    fontSize: 16,
                    fontStyle: FontStyle.italic)),
          ),
        ),
      ],
    );
  }
}




