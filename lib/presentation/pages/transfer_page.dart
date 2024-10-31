import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';
import 'package:provider/provider.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  TextEditingController trasferedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    final saldoProviderWatch = context.watch<SaldoProvider>();
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
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: trasferedController,
              decoration: const InputDecoration(
                prefixIconColor: AppColors.primaryColor,
                prefixIcon: Icon(
                  Icons.attach_money_outlined,
                  size: 70,
                ),
                hintText: "\$ 0.00",
                hintTextDirection: TextDirection.ltr,
                hintStyle: TextStyle(fontSize: 60, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(
            height: myHeight * 0.10,
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
                          "\$${saldoProviderWatch.saldo}",
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
          SizedBox(height: myHeight * 0.05),
          Container(
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
                    style: TextStyle(color: Colors.black,fontSize: 16),
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
                        Navigator.pushNamed(context, Routes.CONTACTSPAGE);
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      iconSize: 20, // Tamaño del icono
                      color: const Color.fromARGB(255, 91, 85, 85), // Color del icono
                    ),
                  ),
                ],
              ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FloatingButtonNavBarQr(),
      bottomNavigationBar: const BottomMainAppBar(),
    );
  }
}
