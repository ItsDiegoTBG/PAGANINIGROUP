import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:screenshot/screenshot.dart';


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
                  Navigator.pushReplacementNamed(context, "qr_page");
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

            if (barcode.rawValue != null) {
              setResult(barcode.rawValue);
              //print(barcode.rawValue);
              await controller
                  .stop()
                  .then((value) => controller.dispose())
                  .then((value) => Navigator.of(context).pop());
            }
          },
        ),
      ),
    );
  }
}
