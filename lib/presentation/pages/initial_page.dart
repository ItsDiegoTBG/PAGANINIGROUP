import 'package:flutter/material.dart';
import 'package:paganini/presentation/widgets/button_with_icon.dart';
import 'package:paganini/utils/colors.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 300,
                  height: 130,
                  child: Image.asset(
                      "assets/image/paganini_logo_horizontal_morado_lila.png")),
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset("assets/image/paganini_icono_morado.png"),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Bienvenido",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                child: Text(
                  "Paga con Paganini",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      color: Colors.grey[900]),
                ),
              ),
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
                  debugPrint("Hola desde login"),
                  Navigator.pushNamed(context, "login_page")
                  },
                icon: Icons.login_rounded,
                textButton: "Iniciar Sesión",
              )
            ],
          ),
        ));
  }
}
