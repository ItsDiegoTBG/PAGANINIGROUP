import 'package:flutter/material.dart';
import 'package:paganini/device/qr_code_scanner.dart';


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
      backgroundColor: Colors.white,
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 25,),
                Expanded(
                  child: Center(
                    child: SizedBox(     
                      width: 200,
                      height: 50,
                      child: Image.asset(
                          "assets/image/paganini_logo_horizontal_morado_lila.png")),
                  ),
                ),
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: const Icon(Icons.arrow_back_rounded))      
              ],
            ),
         Expanded(
          child: QrCodeScanner(setResult: setResult), // Ocupa todo el espacio disponible
        ),
        ],
      )
     // bottomNavigationBar: const BottomMainAppBar(),
    );
  }
}