
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:paganini/presentation/widgets/qr_code_scanner.dart';


class ScannerPage extends StatefulWidget {
  //final CameraController cameraController;
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {

  String? _result;
  void setResult(String result) {
    setState(() => _result = result);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            SizedBox(
                  width: 300,
                  height: 130,
                  child: Image.asset(
                      "assets/image/paganini_logo_horizontal_morado_lila.png")),
          QrCodeScanner(setResult: setResult),
        ],
      )
     // bottomNavigationBar: const BottomMainAppBar(),
    );
  }
}