import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';

import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';
import 'package:paganini/presentation/widgets/text_form_field_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isPasswordVisible = false;

  void signUserIn() async {
  // Muestra el diálogo de carga
  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors.primaryColor,
        ),
      );
    },
  );

  try {
    // Intenta iniciar sesión
    await _auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // ignore: use_build_context_synchronously
    Navigator.pop(context); // Cierra el diálogo de carga

    // Muestra un mensaje de éxito
    _showSnackBar(
      'Inicio de sesión exitoso',
      AppColors.primaryColor,
      topPosition: true,
    );

    // Navega a la pantalla principal
    Navigator.pushNamedAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      Routes.HOME,
      (Route<dynamic> route) => false,
    );
  } on FirebaseAuthException catch (e) {
    // ignore: use_build_context_synchronously
    Navigator.pop(context); // Cierra el diálogo de carga
    // Maneja errores específicos
    if (e.code == 'user-not-found') {
      wrongEmailMessage();
    } else if (e.code == 'wrong-password') {
      wrongPasswordMessage();
    } else {
      _showSnackBar(
        'Error en el inicio de sesión',
      const  Color.fromARGB(255, 236, 45, 55),
        topPosition: true,
      );
    }
  } catch (e) {
    Navigator.pop(context); // Cierra el diálogo de carga
    debugPrint("Error aquí");
    _showSnackBar(
      'Error en el inicio de sesión',
      const Color.fromARGB(255, 236, 45, 55),
      topPosition: true,
    );
  }
}

// Método para mostrar un SnackBar en la parte superior
void _showSnackBar(String message, Color color, {bool topPosition = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 3),
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: color,
    behavior: topPosition ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
    margin: topPosition ? const EdgeInsets.only(top: 10, left: 10, right: 10) : null,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ));
}


  void wrongEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Email Incorrecto"),
          );
        });
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Password Incorrecto"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Bienvenido',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Toggle Buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Email", style: TextStyle(fontSize: 16)),
                TextFormFieldWidget(
                  textInputType: TextInputType.emailAddress,
                    controller: emailController,
                    hintText: "Ingresa tu correo",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return 'Ingresa un email válido';
                      }
                      return null;
                    }),
                const SizedBox(height: 20),
                const Text("Contraseña", style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.primaryColor, width: 2)),
                    hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                    border: const UnderlineInputBorder(),
                    hintText: 'Ingresa tu contraseña',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
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
                          FocusScope.of(context).unfocus();
                          signUserIn();
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
                Align(
                  alignment: Alignment.centerRight,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Nuevo en paganini?",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, Routes.REGISTER);
                      },
                      child: const Text("Registrate Aqui",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.secondaryColor,
                              fontSize: 16,
                              fontStyle: FontStyle.italic)),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            // Forms Container

            Padding(
              padding: EdgeInsets.only(top: myHeight * 0.30),
              child: TextButton(
                onPressed: () {
                  debugPrint("hello world!");
                },
                child: const Text("Necesitas ayuda?",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
