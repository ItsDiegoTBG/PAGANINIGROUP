import 'package:flutter/material.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:paganini/core/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final saldoProviderWatch = context.watch<SaldoProvider>();
    final saldoProviderRead = context.read<SaldoProvider>();

    final userProviderWatch = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const ContentAppBar(),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 150,
            width: 360,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Saldo",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 33,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${saldoProviderWatch.saldo}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 37,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                ),

                //boton de agregar
                ButtonSecondVersion(
                  verticalPadding: 2.0,
                  horizontalPadding: 3.5,
                  text: "Agregar",
                  function: () {
                    Navigator.pushReplacementNamed(context, Routes.RECHARGE);
                  },
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 22, right: 8, bottom: 8),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Acciones Rápidas",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )),
          ),

          //solo de prueba
          const Text("Para ejemplo didactico"),
          Text(
              "Inicio de cuenta con ${userProviderWatch.user?.email ?? 'usuario no disponible'}")
        ],
      ),
      floatingActionButton: const FloatingButtonNavBarQr(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomMainAppBar(),
    );
  }
}
