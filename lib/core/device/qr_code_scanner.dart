import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/helpers/show_animated_snackbar.dart';
import 'package:paganini/presentation/pages/navigation_page.dart';
import 'package:paganini/presentation/pages/payment/payment_page.dart';
import 'package:paganini/presentation/providers/payment_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';
class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({
    required this.setResult,
    super.key,
  });

  final Function setResult;
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: 220,
                height: 100,
                child: Image.asset(
                    "assets/image/paganini_logo_horizontal_morado_lila.png")),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_rounded)),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              final barcode = barcodes.first;
              final data = barcode.rawValue;

              if (data != null) {
                // Verificación de usuario escaneándose a sí mismo
                if (data == userProvider.currentUser?.id) {
                  ShowAnimatedSnackBar.show(
                      context,
                      "No puedes pagarte a ti mismo",
                      Icons.error,
                      AppColors.redColors);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const NavigationPage(initialIndex: 1)));
                  return;
                }

                setResult(data);
                controller.stop();
                try {
                  final databaseRef =
                      FirebaseDatabase.instance.ref('/users/$data');
                  final snapshot = await databaseRef.get();

                  if (snapshot.exists) {
                    paymentProvider.initializeUserPaymentData(data);
                    // ignore: use_build_context_synchronously
                    ShowAnimatedSnackBar.show(context, "Escaneo Correcto",
                        Icons.check, AppColors.greenColors);
                    Navigator.pushReplacement(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentPage(dataId: data)),
                    );
                  } else {
                    // ignore: use_build_context_synchronously
                    ShowAnimatedSnackBar.show(context, "El usuario no existe",
                        Icons.error, AppColors.redColors);
                  }
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  ShowAnimatedSnackBar.show(context, "Error al escanear",
                      Icons.error, AppColors.redColors);
                }
              } else {
                ShowAnimatedSnackBar.show(
                    context, "QR inválido", Icons.error, AppColors.redColors);
              }
            },
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF6A1B9A), // Color morado que combina con tu logo
                  width: 3.0,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6A1B9A).withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Esquinas decorativas
                  Positioned(
                    top: 0,
                    left: 0,
                    child: _buildCorner(true, true),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _buildCorner(true, false),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: _buildCorner(false, true),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _buildCorner(false, false),
                  ),
                ],
              ),
            ),
          ),
         
        ],
      ),
    );
  }

  Widget _buildCorner(bool isTop, bool isLeft) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? BorderSide.none : BorderSide(color: Color(0xFF6A1B9A), width: 3),
          bottom: isTop ? BorderSide(color: Color(0xFF6A1B9A), width: 3) : BorderSide.none,
          left: isLeft ? BorderSide.none : BorderSide(color: Color(0xFF6A1B9A), width: 3),
          right: isLeft ? BorderSide(color: Color(0xFF6A1B9A), width: 3) : BorderSide.none,
        ),
      ),
    );
  }
}