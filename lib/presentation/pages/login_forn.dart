import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';
import 'package:paganini/presentation/widgets/textfile_form.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  LoginFromState createState() => LoginFromState();
}

 class LoginFromState extends State<LoginForm> { 
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser() async {
   
    if (_formKey.currentState!.validate()) {
      try {
       
        await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión exitoso')),
        );

    
        Navigator.pushReplacementNamed(context, '/home'); 
        Navigator.pushNamedAndRemoveUntil(
                      context, Routes.HOME, (Route<dynamic> route) => false);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Email", style: TextStyle(fontSize: 16)),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Ingresa un email válido';
                  }
                  return null;
                },
        ),
        const SizedBox(height: 20),
        const Text("Contraseña", style: TextStyle(fontSize: 16)),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Ingresa tu contraseña',
            suffixIcon: Icon(Icons.visibility),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ButtonWithoutIcon(
                text: "Iniciar Sesion",
                onPressed: () {
                  debugPrint("INICIANDO SESION");
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.HOME, (Route<dynamic> route) => false);
                },
              ),
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
    @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
