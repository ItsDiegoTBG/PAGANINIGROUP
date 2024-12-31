import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/datasources/userservice.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/credit_card_ui.dart';
import 'package:paganini/presentation/widgets/floating_button_paganini.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final String? dataId;

  const PaymentPage({super.key, required this.dataId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController saldoController = TextEditingController();
  List<TextEditingController> saldoControllers = [];
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final creditCardProviderWatch = context.read<CreditCardProvider>();
      final creditCards = creditCardProviderWatch.creditCards;
      debugPrint(
          "Las tarjeta de credito que trajo son : ${creditCards.length}");
      if (creditCards.isNotEmpty) {
        setState(() {
          saldoControllers = List.generate(creditCards.length, (index) {
            return TextEditingController();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    // Limpia los controladores al final
    for (var controller in saldoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    final saldo = context.watch<SaldoProvider>().saldo;
    final creditCardProviderWatch = context.watch<CreditCardProvider>();
    final creditCards = creditCardProviderWatch.creditCards;
final userId = context.read<UserProvider>().user!.uid;
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
          firstPart(userService, context,userId),
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
                        borderRadius:
                            BorderRadius.circular(20), // Borde circular
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Borde circular
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
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
          const Text(
            "Con tarjeta",
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic),
          ),
          if (saldoControllers.isNotEmpty)
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
                                    bottom:
                                        16), // Espaciado horizontal adicional
                                child: SizedBox(
                                  width:
                                      150, // Ancho fijo para el TextFormField
                                  child: TextFormField(
                                    controller: saldoControllers[index],
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 12),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20), // Borde circular
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20), // Borde circular
                                        borderSide: const BorderSide(
                                          color: AppColors.primaryColor,
                                          width: 2,
                                        ),
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
                                    scale:
                                        1.0, // Ajusta la escala si es necesario
                                    child: Opacity(
                                      opacity:
                                          1, // Ajusta la opacidad si es necesario
                                      child: SizedBox(
                                        width:
                                            300, // Establecemos un ancho fijo para que la tarjeta esté recortada
                                        child: ClipRect(
                                          child: Align(
                                            alignment: Alignment
                                                .centerLeft, // Ajusta la alineación para mostrar solo la parte izquierda de la tarjeta
                                            widthFactor:
                                                0.5, // Esto hará que solo se vea la mitad de la tarjeta
                                            child: CreditCardWidget(
                                              balance:
                                                  creditCards[index].balance,
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
          const SizedBox(
            height: 25,
          )
        ],
      ),
      floatingActionButton: FloatingButtonPaganini(iconData: Icons.arrow_back_rounded,onPressed: (){
        Navigator.pop(context);
      },),

    );
  }

  Row firstPart(UserService userService, BuildContext context,String userId) {
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
              onPressed: () async {
                // Obtén el estado del proveedor sin escucharlo
                final creditCardProviderWatch =
                    context.read<CreditCardProvider>();
                final creditCards = creditCardProviderWatch.creditCards;
                double totalPago = 0.0;

                // Accede a los valores de saldo sin reconstruir el widget
                final saldoProviderRead = context.read<SaldoProvider>();
                final saldo = saldoProviderRead.saldo;

                // Convierte el saldo ingresado a double
                double valueSaldo =
                    double.tryParse(saldoController.text) ?? 0.0;

                if (valueSaldo >= 0.0) {
                  if (valueSaldo <= saldo) {
                    // Realiza el descuento en el saldo
                    saldoProviderRead.subRecharge(valueSaldo);
                    totalPago += valueSaldo;
                  } else {
                    AnimatedSnackBar(
                      duration: const Duration(seconds: 3),
                      builder: ((context) {
                        return const MaterialAnimatedSnackBar(
                          iconData: Icons.check,
                          messageText: 'Saldo Insuficiente',
                          type: AnimatedSnackBarType.warning,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          backgroundColor: Color.fromARGB(255, 222, 53, 48),
                          titleTextStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 10,
                          ),
                        );
                      }),
                    ).show(context);
                    return;
                  }
                }

                // Verifica cada tarjeta y el saldo ingresado para cada una
                for (int i = 0; i < creditCards.length; i++) {
                  double saldoPago =
                      double.tryParse(saldoControllers[i].text) ?? 0.0;

                  if (saldoPago > 0) {
                    double tarjetaSaldo = creditCards[i].balance;

                    if (tarjetaSaldo >= saldoPago) {
                      // Realiza el descuento en la tarjeta y actualiza el saldo
                      double nuevoSaldo = tarjetaSaldo - saldoPago;
                      await creditCardProviderWatch.updateBalance(userId,
                          creditCards[i].id, nuevoSaldo);

                      totalPago += saldoPago;
                    } else {
                      AnimatedSnackBar(
                        duration: const Duration(seconds: 3),
                        builder: ((context) {
                          return MaterialAnimatedSnackBar(
                            iconData: Icons.check,
                            messageText:
                                'Saldo Insuficiente en ${creditCards[i].cardHolderFullName}',
                            type: AnimatedSnackBarType.info,
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(20)),
                            backgroundColor:
                                const Color.fromARGB(255, 59, 84, 244),
                            titleTextStyle: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 10,
                            ),
                          );
                        }),
                      ).show(context);
                      return;
                    }
                  }
                }

                // Verifica si se realizaron pagos
                if (totalPago > 0) {
                  AnimatedSnackBar(
                    duration: const Duration(seconds: 3),
                    builder: ((context) {
                      return MaterialAnimatedSnackBar(
                        iconData: Icons.check,
                        messageText:
                            'Pago realizado con exito! Total \$${totalPago.toStringAsFixed(2)}',
                        type: AnimatedSnackBarType.info,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        backgroundColor: const Color.fromARGB(255, 30, 219, 17),
                        titleTextStyle: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 10,
                        ),
                      );
                    }),
                  ).show(context);

                  Future.delayed(const Duration(seconds: 2), () {
                    // Este código se ejecutará después del retraso de 2 segundos
                    Navigator.pushNamed(context, Routes.HOME);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
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
