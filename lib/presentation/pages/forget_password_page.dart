import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/widgets/buttons/button_with_icon.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';
import 'package:paganini/presentation/widgets/text_form_field_widget.dart';


class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Si el correo está registrado, recibirás un enlace para restablecer tu contraseña.')),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'Usuario no encontrado.';
      } else {
        errorMessage = 'Ocurrió un error: ${e.message}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recuperar Contraseña')),
      body: SingleChildScrollView(
        padding:  const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 0),
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
            const Text('Ingrese su correo electrónico para recuperar su contraseña:'),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Enviar enlace de recuperación'),
            ),
          ],
        ),
      ),
    );
  }
}