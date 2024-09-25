import 'package:flutter/material.dart';
import 'package:paganini/device/qr_code_scanner.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';


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
      appBar: AppBar(
        backgroundColor:Colors.white,
        automaticallyImplyLeading: false,
        title: const ContentAppBar(),
      ),
      backgroundColor: Colors.white,
      body: Expanded(
       child: QrCodeScanner(setResult: setResult), 
      )
    );
  }
}