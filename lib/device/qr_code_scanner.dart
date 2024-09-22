import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({
    required this.setResult,
    super.key,
  });

  final Function setResult;
  final MobileScannerController controller = MobileScannerController();

  Future<void> _launchUrl(String url) async {
    final _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: (BarcodeCapture capture) async {
        final List<Barcode> barcodes = capture.barcodes;
        final barcode = barcodes.first;

        if (barcode.rawValue != null) {
          setResult(barcode.rawValue);

          if (barcode.rawValue!.contains('youtube.com') || barcode.rawValue!.contains('youtu.be')) {
            _launchUrl(barcode.rawValue!);
          }

          await controller
              .stop()
              .then((value) => controller.dispose())
              .then((value) => Navigator.of(context).pop());
        }
      },
    );
  }
}
