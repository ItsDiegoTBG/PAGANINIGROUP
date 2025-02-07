import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/data/local/notification_service.dart';
import 'package:paganini/domain/entity/user_entity.dart';
import 'package:paganini/helpers/show_animated_snackbar.dart';
import 'package:paganini/presentation/pages/login/loading_screen.dart';
import 'package:paganini/presentation/pages/transfer/transfer_receipt_page.dart';
import 'package:paganini/presentation/providers/biometric_auth_provider.dart';
import 'package:paganini/presentation/providers/contact_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';

import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class ConfirmTransfer extends StatefulWidget {
  final double valueTransfered;
  const ConfirmTransfer({required this.valueTransfered, super.key});
  @override
  State<ConfirmTransfer> createState() => _ConfirmTransferState();
}

class _ConfirmTransferState extends State<ConfirmTransfer> {
  @override
  Widget build(BuildContext context) {
    final contactProviderRead = context.read<ContactProvider>();
    final saldoProviderRead = context.read<SaldoProvider>();
    final notificationService = Provider.of<NotificationService>(context);
    final contactProviderWacth = context.watch<ContactProvider>();
    final bioProvider =
        Provider.of<BiometricAuthProvider>(context, listen: false);
    final UserEntity? contactUserTransfered = contactProviderWacth.contactUser;

    Future<void> confirmTransfer() async {
      final contactProviderRead = context.read<ContactProvider>();
      final saldoProviderRead = context.read<SaldoProvider>();
      final notificationService = Provider.of<NotificationService>(context, listen: false);
      final contactProviderWatch = context.read<ContactProvider>();
      final UserEntity? contactUserTransfered = contactProviderWatch.contactUser;
      debugPrint("Función antes del try");
      try {
        debugPrint("Dato del usuario del contacto que se ha transferido");
        debugPrint("Teléfono del usuario del contacto: ${contactUserTransfered?.phone}");
        debugPrint("Nombre del usuario del contacto: ${contactUserTransfered?.firstname}");
        
        saldoProviderRead.subRecharge(widget.valueTransfered);
        contactProviderRead.resetContact();
        contactProviderWatch.updateUserSaldo(contactUserTransfered!, widget.valueTransfered);
        
        notificationService.showNotification(
          "Transferencia Exitosa",
          "Haz transferido de manera exitosa",
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransferReceipt(
              valueTransfered: widget.valueTransfered,
              userByTransfered: contactUserTransfered,
            ),
          ),
        );
      } catch (e) {
        debugPrint("Error durante la transferencia: $e");
      }
    }

    Future<void> authenticateTransfer() async {
      try {
        await bioProvider.authenticateTransferWithBiometrics();

        showDialog(
          context: context,
          barrierDismissible:
              false, // Evita cerrar el diálogo manualmente
          builder: (context) {
            return const Center(child: LoadingScreen());
          },
        );
        await Future.delayed(const Duration(seconds: 2));

        // Cierra el diálogo después de la animación
        Navigator.pop(context);

        // Confirma la transferencia
        debugPrint("Calling confirmTransfer()...");
        confirmTransfer();
      } catch (e) {
        // Asegúrate de cerrar el diálogo en caso de error
        Navigator.pushNamed(context, Routes.CONFTRANSFER);

        // Muestra el mensaje de error
        debugPrint(e.toString());
        ShowAnimatedSnackBar.show(context, "Debes registrar tus datos biométricos.",Icons.error, AppColors.redColors,seconds: 4);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const ContentAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Confirmar Transferencia",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 105,
                        height: 110,
                        child: Image.asset("assets/image/img_transfer.png")),
                    // const Icon(FontAwesomeIcons.handHoldingHeart),
                    Text(
                      '\$${widget.valueTransfered}',
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Saldo Restante:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${saldoProviderRead.saldo - widget.valueTransfered}",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 64),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Beneficiario',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 64),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 80, // Ancho fijo para las etiquetas
                        child: Text(
                          "Nombre: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        // Usamos Expanded para que el texto ocupe el espacio restante
                        child: Text(
                          contactUserTransfered?.firstname ??
                              'N/A', // Añadí un valor por defecto en caso de que sea null
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 80, // Mismo ancho para alinear con "Nombre"
                        child: Text(
                          "Teléfono: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        // Expandido para el texto
                        child: Text(
                          contactUserTransfered?.phone ??
                              'N/A', // Añadí un valor por defecto en caso de que sea null
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:
                            80, // Mismo ancho para alinear con las demás etiquetas
                        child: Text(
                          "Nro: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        // Expandido para el texto
                        child: Text(
                          "2203234040", // Aquí el valor está estático pero también podrías usar algo dinámico
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonSecondVersion(
                  text: "Confirmar",
                  function: () async {
                    await authenticateTransfer();
                  },
                  horizontalPadding: 70,
                  buttonWidth: 300,
                  buttonHeight: 60,
                ),
                const SizedBox(
                  height: 10,
                ),
                ButtonSecondVersion(
                  text: "Regresar",
                  function: () {
                    Navigator.pop(context);
                  },
                  horizontalPadding: 70,
                  buttonWidth: 300,
                  buttonHeight: 60,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
