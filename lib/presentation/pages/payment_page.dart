import 'package:flutter/material.dart';
import 'package:paganini/data/datasources/userservice.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';

class PaymentPage extends StatelessWidget {
  final String? dataId;

  const PaymentPage({super.key, required this.dataId});

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    return Scaffold(
      appBar: AppBar(
        title: const ContentAppBar(),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 20,),
          dataId != null
              ? FutureBuilder<Map<String, dynamic>?>(
                  future: userService.fetchUserById(dataId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Muestra un cargador mientras se obtienen los datos
                    } else if (snapshot.hasError) {
                      return const Text(
                          'Error al cargar datos'); // Muestra un mensaje de error
                    } else if (snapshot.hasData) {
                      final userData = snapshot.data!;
                      return Text(
                        "Pagar a ${userData['firstname']} $dataId", // Muestra el nombre del usuario
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      );
                    } else {
                      return const Text(
                          'Usuario no encontrado'); // Si el usuario no existe
                    }
                  },
                )
              : const Text(
                  'ID de usuario no proporcionado',
                  style: TextStyle(color: Colors.black),
                ),
        ],
      ),
      floatingActionButton: const FloatingButtonNavBarQr(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomMainAppBar(),
    );
  }
}
