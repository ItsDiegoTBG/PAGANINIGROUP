import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:paganini/presentation/widgets/buttons/button_with_icon.dart';
import 'package:provider/provider.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                width: size.width * 0.9,
                height: 130,
                child: Image.asset(
                    "assets/image/paganini_logo_horizontal_morado_lila.png")),
            Container(
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode
                    ?  Colors.grey[900] // Color de fondo
                    : Colors.white, // Color de fondo
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              width: size.width * 0.70,
              height: 290,
              child: Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Center(
                    child: Image.asset(
                  "assets/image/paganini_icono_morado.png",
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                )),
              ),
            ),
            Column(
              children: [
                Text(
                  "Bienvenido",
                  style: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 20),
                  child: Text(
                    "Paga con Paganini",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  ButtonWithIcon(
                    function: () {},
                    icon: Icons.pin_rounded,
                    textButton: "6 Digitos",
                  ),
                  ButtonWithIcon(
                    function: () {},
                    icon: Icons.fingerprint_rounded,
                    textButton: "Biométrico",
                  ),
                  ButtonWithIcon(
                    function: () => {
                      debugPrint("Hola desde auth page "),
                      Navigator.pushNamed(context, Routes.LOGIN)
                    },
                    icon: Icons.login_rounded,
                    textButton: "Iniciar Sesión",
                  )
                ],
              ),
            )
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.INTRODUCTIONPAGE);
          },
          child: const Icon(Icons.arrow_back),
        )*/
    );
  }
}
