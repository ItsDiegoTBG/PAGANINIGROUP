import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';

import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/local/notification_service.dart';
import 'package:paganini/helpers/request_notification_permission.dart';
import 'package:paganini/presentation/pages/login/loading_screen.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/domain/usecases/authenticate_with_biometrics.dart';
import 'package:paganini/presentation/providers/biometric_auth_provider.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';
import 'package:paganini/presentation/widgets/floating_button_paganini.dart';
import 'package:paganini/presentation/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'dart:io';

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

  void signUserIn(NotificationService notificationService) async {
    // Muestra el diálogo de carga
    final biometricProvider = context.read<BiometricAuthProvider>();
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que el usuario cierre el diálogo manualmente
      builder: (context) {
        return const Center(child: LoadingScreen());
      },
    );

    try {
      // Intenta iniciar sesión
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await biometricProvider.saveCredentials(emailController.text.trim(), passwordController.text.trim());

      await Future.delayed(const Duration(seconds: 2));

      Navigator.pop(context);
      await RequestNotificationPermission.requestNotificationPermission();
      notificationService.showNotification(
          "Inicio de Sesión", "Haz iniciado sesión de manera exitosa");

      // Navega a la siguiente pantalla
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.NAVIGATIONPAGE,
        (Route<dynamic> route) => false,
      );

      // Inicializa el usuario
      final userProvider = context.read<UserProvider>();
      userProvider.initializeUser();
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Cierra el diálogo de carga en caso de error

      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      } else {
        _showSnackBar(
          'Error en el inicio de sesión',
          const Color.fromARGB(255, 236, 45, 55),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Cierra el diálogo de carga en caso de error
      debugPrint("Error aquí: $e");
      _showSnackBar(
        'Error en el inicio de sesión',
        const Color.fromARGB(255, 236, 45, 55),
      );
    }
  }

  // Método para mostrar un SnackBar en la parte superior
  void _showSnackBar(String message, Color color, {bool topPosition = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      behavior:
          topPosition ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
    ));
  }

  void wrongEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Correo Electrónico Incorrecto"),
          );
        });
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Contraseña Incorrecta"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final notificationService =
        Provider.of<NotificationService>(context, listen: false);
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:AppColors.primaryColor,
      body: Stack(
        children: [
          // Fondo con patrón de círculos
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                
              ),
            ),
          ),
          
          // Logo en el centro superior
          Positioned(
            top: MediaQuery.of(context).size.height * 0.12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    "assets/image/paganini_icono_morado.png",
                    
                  ),
                ),
              ),
            ),
          ),
          
          // Tarjeta principal
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Bienvenido',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Email field
                      const Text(
                        "Correo Electrónico",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "youremail@mail.com",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Password field
                      const Text(
                        "Contraseña",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        onSubmitted: (value) => signUserIn(notificationService),
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "• • • • • • •",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible 
                                ? Icons.visibility 
                                : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => signUserIn(notificationService),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Iniciar Sesión",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Olvidaste la clave
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.FORGETPASSWORD);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "Olvidaste la Clave?",
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.grey,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Sign up link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "¿No tienes cuenta? ",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.REGISTER);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                "Registrate",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.INITIAL);
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
    );
  }
}