import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/pages/transfer/confirm_transfer_page.dart';
import 'package:paganini/presentation/pages/transfer/contacts_page.dart';
import 'package:paganini/presentation/providers/contact_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';
import 'package:provider/provider.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  TextEditingController trasferedController = TextEditingController();

  late ContactProvider contactProvider;
  late ContactProvider contactProviderWacth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Inicializa el contactProvider aquí
    contactProvider = context.read<ContactProvider>();
    contactProviderWacth = context.watch<ContactProvider>();
  }

  @override
  void dispose() {
   // contactProviderWacth
   //     .resetContact(); // Reinicia el estado solo si el widget está montado

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    final double valueTransfered = trasferedController.text.isNotEmpty
        ? double.tryParse(trasferedController.text.replaceAll(",", "")) ?? 0.0
        : 0.0;
    final saldoProviderWatch = context.watch<SaldoProvider>();
    final contactTransfered =
        context.watch<ContactProvider>().contactTransfered;
    final contactRead = context.read<ContactProvider>();
    final saldoActual = saldoProviderWatch.saldo;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const ContentAppBar(),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: myWidth * 0.08, top: 10),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Transferencias",
                    style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 24),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Ingrese el monto a tranferir",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: myWidth * 0.08,
                right: myWidth * 0.08,
                top: myHeight * 0.05),
            child: TextFormField(
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 60, color: Colors.black),
              textAlign: TextAlign.end,
              inputFormatters: [
                LengthLimitingTextInputFormatter(8),
              ],
              controller: trasferedController,
              decoration: const InputDecoration(
                prefixIconColor: AppColors.primaryColor,
                prefixIcon: Icon(
                  Icons.attach_money_outlined,
                  size: 70,
                ),
                hintText: "0.00",
                hintTextDirection: TextDirection.ltr,
                hintStyle: TextStyle(fontSize: 60, color: Colors.grey),
              ),
              onChanged: (value) {
                double? enteredValue = double.tryParse(value);

                if (enteredValue != null && enteredValue > 15000) {
                  trasferedController.text = "15000";
                  trasferedController.selection =
                      const TextSelection.collapsed(offset: 5);
                  // Coloca el cursor al final
                  AnimatedSnackBar(
                    duration: const Duration(seconds: 3),
                    builder: ((context) {
                      return const MaterialAnimatedSnackBar(
                        iconData: Icons.error_outline_rounded,
                        messageText: 'Transferencia maxima de 15.000',
                        type: AnimatedSnackBarType.warning,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        backgroundColor: Color.fromARGB(255, 95, 38, 228),
                        titleTextStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 10,
                        ),
                      );
                    }),
                  ).show(context);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un monto';
                }

                // Convertir el valor ingresado a número y eliminar posibles comas
                double? enteredValue =
                    double.tryParse(value.replaceAll(",", ""));

                if (enteredValue == null || enteredValue <= 0) {
                  return 'Por favor ingresa un monto válido';
                }

                // Validación del valor máximo (15000)
                if (enteredValue > 15000) {
                  return 'El monto máximo a transferir es 15000';
                }

                return null;
              },
            ),
          ),
          SizedBox(
            height: myHeight * 0.07,
          ),
          Container(
              height: myHeight * 0.10,
              width: myWidth * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryColor,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //lado izquierdo
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Desde",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        Text(
                          "Nro 2203232323",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      width: myWidth * 0.10,
                    ),
                    //lado derecho
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Saldo disponible",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "\$$saldoActual",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      ],
                    ),

                    //boton de agregar
                  ],
                ),
              )),
          SizedBox(height: myHeight * 0.03),
          Column(
            children: [
              if (contactTransfered != null) ...[
                Padding(
                  padding: EdgeInsets.only(left: myWidth * 0.08),
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Para",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 5,
                  indent: 30,
                  endIndent: 30,
                ),
              ],
              contactTransfered ??
                  selectBeneficiary(myHeight, myWidth, context),
              const SizedBox(
                height: 40,
              ),
              if (contactTransfered != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 25,right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonSecondVersion(
                        text: "Continuar",
                        horizontalPadding: 25,
                        function: () {
                          if (valueTransfered == 0.0) {
                            AnimatedSnackBar(
                              duration: const Duration(seconds: 3),
                              builder: ((context) {
                                return const MaterialAnimatedSnackBar(
                                  iconData: Icons.info_outline_rounded,
                                  messageText:
                                      'No has asigando un monto a la transferencia',
                                  type: AnimatedSnackBarType.info,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  backgroundColor:
                                      Color.fromARGB(255, 60, 108, 219),
                                  titleTextStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 10,
                                  ),
                                );
                              }),
                            ).show(context);
                          } else if (saldoActual == 0.0) {
                            AnimatedSnackBar(
                              duration: const Duration(seconds: 3),
                              builder: ((context) {
                                return const MaterialAnimatedSnackBar(
                                  iconData: Icons.info_outline_rounded,
                                  messageText: 'No hay saldo en el sistema',
                                  type: AnimatedSnackBarType.info,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  backgroundColor:
                                      Color.fromARGB(255, 60, 108, 219),
                                  titleTextStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 10,
                                  ),
                                );
                              }),
                            ).show(context);
                          } else if (valueTransfered <= saldoActual) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConfirmTransfer(
                                          valueTransfered: double.tryParse(
                                              trasferedController.text)!,
                                        )));
                          } else {
                            AnimatedSnackBar(
                              duration: const Duration(seconds: 3),
                              builder: ((context) {
                                return const MaterialAnimatedSnackBar(
                                  iconData: Icons.error_outline_rounded,
                                  messageText: 'EL saldo es insuficiente',
                                  type: AnimatedSnackBarType.error,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  backgroundColor:
                                      Color.fromARGB(255, 203, 21, 88),
                                  titleTextStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 10,
                                  ),
                                );
                              }),
                            ).show(context);
                          }
                        },
                      ),
                      ButtonSecondVersion(
                        horizontalPadding: 25,
                        backgroundColor: Colors.red[400]!,
                          text: "Cancelar",
                          function: () {
                            contactProviderWacth.resetContact();
                            Navigator.pop(context);
                          })
                    ],
                  ),
                )
              ]
            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FloatingButtonNavBarQr(),
      bottomNavigationBar: const BottomMainAppBar(),
    );
  }

  Container selectBeneficiary(
      double myHeight, double myWidth, BuildContext context) {
    return Container(
        // padding: EdgeInsets.only(top: 10,bottom: 10),
        height: myHeight * 0.07,
        width: myWidth * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.secondaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Escoge al beneficiario",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(
              width: myWidth * 0.10,
            ),
            Container(
              width: 40.0, // Ajusta el tamaño del círculo
              height: 40.0,
              decoration: const BoxDecoration(
                color: Colors.white, // Color de fondo del círculo
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactsPage()));
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded),
                iconSize: 20, // Tamaño del icono
                color: const Color.fromARGB(255, 91, 85, 85), // Color del icono
              ),
            ),
          ],
        ));
  }
}
