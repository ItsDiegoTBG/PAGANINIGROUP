import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/datasources/userservice.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final String? dataId;

  const PaymentPage({super.key, required this.dataId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController saldoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    final saldo = context.watch<SaldoProvider>().saldo;
    final creditCardProviderWatch = context.watch<CreditCardProvider>();

    // Obtenemos la lista de tarjetas actualizada directamente del provider
    final creditCards = creditCardProviderWatch.creditCards;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const ContentAppBar(),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          firstPart(userService, context),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 30,
                    right: 10,
                    top: 16,
                    bottom: 16), // Espaciado horizontal adicional
                child: SizedBox(
                  width: 150, // Ancho fijo para el TextFormField
                  child: TextFormField(
                    controller: saldoController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.black), // Borde negro
                        borderRadius:
                            BorderRadius.circular(0), // Sin bordes circulares
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2), // Borde negro al enfocar
                        borderRadius:
                            BorderRadius.circular(0), // Sin bordes circulares
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.black), // Borde negro por defecto
                        borderRadius:
                            BorderRadius.circular(0), // Sin bordes circulares
                      ),
                      hintText: '', // Sin texto visible
                    ),
                    style: const TextStyle(
                        color: Colors
                            .black), // Asegura que el texto ingresado sea visible
                    keyboardType: TextInputType.number, // Para números
                    obscureText:
                        false, // Si quieres ocultar datos como contraseñas
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 180, // Controla el tamaño del contenedor
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primaryColor,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Saldo",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "\$$saldo",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Text("Con tarjeta",style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.w600,fontStyle: FontStyle.italic),),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: creditCards.length, // Número de tarjetas
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30,
                                  right: 10,
                                  top: 16,
                                  bottom: 16), // Espaciado horizontal adicional
                              child: SizedBox(
                                width: 150, // Ancho fijo para el TextFormField
                                child: TextFormField(
                                  controller: saldoController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 12),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black), // Borde negro
                                      borderRadius: BorderRadius.circular(
                                          0), // Sin bordes circulares
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black,
                                          width: 2), // Borde negro al enfocar
                                      borderRadius: BorderRadius.circular(
                                          0), // Sin bordes circulares
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors
                                              .black), // Borde negro por defecto
                                      borderRadius: BorderRadius.circular(
                                          0), // Sin bordes circulares
                                    ),
                                    hintText: '', // Sin texto visible
                                  ),
                                  style: const TextStyle(
                                      color: Colors
                                          .black), // Asegura que el texto ingresado sea visible
                                  keyboardType:
                                      TextInputType.number, // Para números
                                  obscureText: false,
                                ),
                              ),
                            ),
                            // Aquí reemplazamos el contenedor de saldo por el widget de tarjeta de crédito
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Transform.scale(
                                  scale:1.0, // Ajusta la escala si es necesario
                                  child: Opacity(
                                    opacity:1, // Ajusta la opacidad si es necesario
                                    child: SizedBox(
                                      width:300, // Establecemos un ancho fijo para que la tarjeta esté recortada
                                      child: ClipRect(
                                        child: Align(
                                          alignment: Alignment.centerLeft, // Ajusta la alineación para mostrar solo la parte izquierda de la tarjeta
                                          widthFactor: 0.5, // Esto hará que solo se vea la mitad de la tarjeta
                                          child: CreditCardWidget(
                                            balance: creditCards[index].balance,
                                            cardHolderFullName:
                                                creditCards[index]
                                                    .cardHolderFullName,
                                            cardNumber:
                                                creditCards[index].cardNumber,
                                            validThru:
                                                creditCards[index].validThru,
                                            cardType:
                                                creditCards[index].cardType,
                                            cvv: creditCards[index].cvv,
                                            color: creditCards[index].color,
                                            isFavorite:
                                                creditCards[index].isFavorite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25,)
        ],
      ),
      floatingActionButton: const FloatingButtonNavBarQr(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomMainAppBar(),
    );
  }

  Row firstPart(UserService userService, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primaryColor,
            ),
            child: widget.dataId != null
                ? Center(
                    child: FutureBuilder<Map<String, dynamic>?>(
                      future: userService.fetchUserById(widget.dataId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Muestra un cargador mientras se obtienen los datos
                        } else if (snapshot.hasError) {
                          return const Text(
                              'Error al cargar datos'); // Muestra un mensaje de error
                        } else if (snapshot.hasData) {
                          final userData = snapshot.data!;
                          return Text(
                            "Pagar a ${userData['firstname']}", // Muestra el nombre del usuario
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          );
                        } else {
                          return const Text(
                              'Usuario no encontrado'); // Si el usuario no existe
                        }
                      },
                    ),
                  )
                : const Text(
                    'ID de usuario no proporcionado',
                    style: TextStyle(color: Colors.black),
                  ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                //Proceso de aceptacion
                Navigator.pushNamed(context, Routes.HOME);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Ajusta el valor para más o menos curvatura
                ),
                backgroundColor: AppColors.secondaryColor,
                minimumSize: const Size(133, 50),
              ),
              child: const Text(
                'Pagar',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Ajusta el valor para más o menos curvatura
                ),
                backgroundColor: Colors.red[300],
                minimumSize: const Size(120, 50),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ],
        )
      ],
    );
  }
}
