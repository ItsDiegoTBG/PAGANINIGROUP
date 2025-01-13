import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/domain/entity/user_entity.dart';
import 'package:paganini/presentation/providers/contact_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:intl/intl.dart';
import 'package:paganini/presentation/widgets/buttons/button_second_version.dart';

import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class TransferReceipt extends StatelessWidget {
  final double valueTransfered;
  final UserEntity userByTransfered;

  const TransferReceipt(
      {super.key,
      required this.valueTransfered,
      required this.userByTransfered});

  @override
  Widget build(BuildContext context) {
    final contactProvider = context.read<ContactProvider>();
    final contactProviderWacth = context.watch<ContactProvider>();
    final userProvider = context.read<UserProvider>();
    final UserEntity? contactUserTransfered = contactProviderWacth.contactUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const ContentAppBar(),
      ),
      body: SingleChildScrollView(
        // Permite desplazarse si el contenido es demasiado grande
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("Transferencia Exitosa",
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
              const SizedBox(height: 10),
              Text(
                'Has transferido',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 105,
                        height: 110,
                        child: Image.asset("assets/image/img_transfer.png")),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        '\$$valueTransfered',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1, height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoRow(
                      label: 'De propietario:',
                      value: userProvider.currentUser?.firstname ?? 'N/A'),
                  const InfoRow(label: 'A la cuenta:', value: '220323****'),
                  InfoRow(
                      label: 'Beneficiario:',
                      value: userByTransfered.firstname),
                  InfoRow(
                    label: 'Email:',
                    value: userByTransfered.email,
                  ),
                  InfoRow(label: 'Fecha:', value: getCurrentFormattedDate()),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                      child: ButtonSecondVersion(
                    backgroundColor: AppColors.primaryColor,
                    colorText: Colors.white,
                    text: "Guardar comprobante",
                    function: () {},
                    buttonWidth: 280,
                    buttonHeight: 55,
                    fontSize: 18,
                  ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(thickness: 1, height: 30),
              ButtonSecondVersion(
                text: "Realiza otra transferencia",
                function: () {
                  contactProviderWacth.resetContact();
                  Navigator.pushNamed(context, Routes.TRANSFERPAGE);
                },
                buttonWidth: 300,
                buttonHeight: 60,
                fontSize: 16,
              ),
              const SizedBox(
                height: 10,
              ),
              ButtonSecondVersion(
                text: "Regresar al inicio",
                function: () {
                  Navigator.pushNamedAndRemoveUntil(
                    // ignore: use_build_context_synchronously
                    context,
                    Routes.NAVIGATIONPAGE,
                    (Route<dynamic> route) => false,
                  );

                  contactProviderWacth.resetContact();
                },
                buttonWidth: 300,
                buttonHeight: 60,
                fontSize: 16,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

String getCurrentFormattedDate() {
  // Obtiene la fecha y hora actual
  DateTime now = DateTime.now();

  // Formatea la fecha en el formato deseado
  String formattedDate = DateFormat('d/M/yyyy hh:mm a').format(now);

  // Devuelve la fecha formateada
  return formattedDate;
}
