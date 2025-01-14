import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/widgets/buttons/button_with_icon.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';
import 'package:paganini/presentation/widgets/text_form_field_widget.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});
  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
            content: Text('Por favor ingresa un correo electronico',style: TextStyle(fontSize: 16, color: Colors.white),)),
      );
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      clearText();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: AppColors.primaryColor,
        duration: Duration(seconds: 3),
        content: Text(
          'Si el correo está registrado, recibirás un enlace para restablecer tu contraseña.',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ));
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'Usuario no encontrado.';
      } else {
        errorMessage = 'Ocurrió un error: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          content: Text(
            errorMessage,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          )));
    }
  }

  void clearText() {
    _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                  width: 300,
                  height: 100,
                  child: Image.asset(
                      "assets/image/paganini_logo_horizontal_negro.png")),
              const SizedBox(
                height: 60,
              ),
              const Text(
                'Ingrese su correo electrónico para recuperar su contraseña',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              TextFormFieldWidget(
                controller: _emailController,
                hintText: "Correo electronico",
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              ButtonWithoutIcon(
                  text: "Enviar enlace de Recuperacion",
                  onPressed: _resetPassword)
            ],
          ),
        ),
      ),
    );
  }
}
