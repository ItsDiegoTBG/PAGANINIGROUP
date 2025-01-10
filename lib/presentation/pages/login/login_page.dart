import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';

import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/local/notification_service.dart';
import 'package:paganini/helpers/request_notification_permission.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
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
    showDialog(
      context: context,
      barrierDismissible:
          false, // Evita que el usuario cierre el diálogo manualmente
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

      // Una vez exitoso, cierra el diálogo
      Navigator.pop(context);
       await RequestNotificationPermission.requestNotificationPermission();
       notificationService.showNotification("Inicio de Sesion", "Haz iniciado sesion de manera exitosa");
      // Muestra el snackbar de éxito
      /*AnimatedSnackBar(
        duration: const Duration(seconds: 3),
        builder: ((context) {
          return MaterialAnimatedSnackBar(
            iconData: Icons.check,
            messageText: 'Inicio de sesión exitoso',
            type: AnimatedSnackBarType.success,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            backgroundColor: Colors.green[400],
            titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 16,
            ),
          );
        }),
      ).show(context);*/

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
    //double myHeight = MediaQuery.of(context).size.height;
    final themeProvider = Provider .of<ThemeProvider>(context, listen: false);
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
     // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
               Text(
                'Bienvenido',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: themeProvider.isDarkMode ? Colors.white:Colors.black),
              ),
              SizedBox(
                  width: 300,
                  height: 100,
                  child: themeProvider.isDarkMode ? Image.asset(
                      "assets/image/paganini_logo_horizontal_morado.png"): Image.asset(
                      "assets/image/paganini_logo_horizontal_negro.png")),
              const SizedBox(
                height: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Email",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 5,
                  ),
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
                  const Text("Contraseña",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    onFieldSubmitted: (value) {
                      signUserIn(notificationService);
                    },
                    obscureText: !_isPasswordVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: _isPasswordVisible
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Borde circular
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Borde circular
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      hintText: 'Ingresa tu contraseña',
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18, // Tamaño de texto del hint
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, // Espaciado vertical
                        horizontal: 20, // Espaciado horizontal
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 18, // Tamaño del texto ingresado
                      height: 1.5, // Espaciado entre líneas
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonWithoutIcon(
                          text: "Iniciar Sesion",
                          onPressed: () async {
                            debugPrint("INICIANDO SESION");
                            signUserIn(notificationService);
                            //await RequestNotificationPermission.requestNotificationPermission();
                            //notificationService.showNotification("Inicio de Sesion", "Haz iniciado sesion de manera exitosa");
                             
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
                       Text(
                        "Nuevo en paganini?",
                        style: TextStyle(
                            color: themeProvider.isDarkMode ? Colors.white:Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.REGISTER);
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
            ],
          ),
        ),
      ),
      floatingActionButton: Platform.isIOS ? FloatingButtonPaganini(iconData: Icons.arrow_back,onPressed: (){
        Navigator.pop(context);
      },) : null,
    );
  }
}
