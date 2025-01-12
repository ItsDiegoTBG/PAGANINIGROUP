import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/presentation/pages/navigation_page.dart';
import 'package:paganini/presentation/pages/payment/payment_page.dart';

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({
    required this.setResult,
    super.key,
  });

  final Function setResult;
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.only(left: 1),
            child: SizedBox(
                width: 220,
                height: 100,
                child: Image.asset(
                    "assets/image/paganini_logo_horizontal_morado_lila.png")),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 1),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_rounded)),
          )
        ]),
      ),
      backgroundColor: Colors.white,
      body: Expanded(
        child: MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              final barcode = barcodes.first;
              final data = barcode.rawValue;
              if (data != null) {
                setResult(barcode.rawValue);
                controller.stop();
                try {
                  final databaseRef =
                      FirebaseDatabase.instance.ref('/users/$data');
                  debugPrint("El databse databseRef es : $databaseRef");
                  final snapshot = await databaseRef.get();
                  debugPrint("El usuario de este Qr si existe");
                  if (snapshot.exists) {
                    setResult(data);
                    await controller
                        .stop()
                        .then((value) => controller.dispose())
                        .then((value) {
                      AnimatedSnackBar(
                        duration: const Duration(seconds: 2),
                        builder: ((context) {
                          return  MaterialAnimatedSnackBar(
                            iconData: Icons.check,
                            messageText: 'Escanero Correcto',
                            type: AnimatedSnackBarType.error,
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            backgroundColor: Colors.green[800]!,
                            titleTextStyle: const  TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 10,
                            ),
                          );
                        }),
                      ).show(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentPage(dataId: data)),
                      );
                    });
                  } else {
                    debugPrint(
                        "El usuario de este Qr no existe o no es QR valido el else del try ");
                    return;
                  }
                } catch (e) {
                  debugPrint(
                      "El usuario de este Qr no existe o no es QR valido del catch ");

                  AnimatedSnackBar(
                    duration: const Duration(seconds: 2),
                    builder: ((context) {
                      return  MaterialAnimatedSnackBar(
                        iconData: Icons.check,
                        messageText: 'Ocurrio un error al escanear el QR',
                        type: AnimatedSnackBarType.error,
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        backgroundColor: Colors.red[800]!,
                        titleTextStyle: const  TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 10,
                        ),
                      );
                    }),
                  ).show(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const NavigationPage(initialIndex: 1)));

                  return;
                }
              } else {
                AnimatedSnackBar(
                  duration: const Duration(seconds: 2),
                  builder: ((context) {
                    return const MaterialAnimatedSnackBar(
                      iconData: Icons.check,
                      messageText: 'Ocurrio un error al escanear el QR',
                      type: AnimatedSnackBarType.error,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      backgroundColor: Colors.red,
                      titleTextStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 10,
                      ),
                    );
                  }),
                ).show(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const NavigationPage(initialIndex: 1)));
                return;
              }
            }),
      ),
    );
  }
}
