import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';
import 'package:paganini/device/qr_code_scanner.dart';
import 'package:paganini/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  String? _result;


  final screenshotController = ScreenshotController();

  Future<String> get directoryPath async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    return directory;
  }



  void setResult(String result) {
    setState(() => _result = result);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, right: 10),
              child: SizedBox(
                width: 200,
                child: Image.asset(
                    "assets/image/paganini_logo_horizontal_morado.png"),
              ),
            ),
            Text(_result ?? 'No result'),
            Screenshot(
              controller: screenshotController,
              child: const  QrContainer(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
             
                children: [
                  IconButton(
                      onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  QrCodeScanner(setResult: setResult),
                            ),
                          ),
                      icon: const Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 40,
                      )),
                  
                  Padding(
                    padding: const EdgeInsets.only(right: 25,left: 25),
                    child: ButtonWithoutIcon(
                      text: "Guardar Qr",
                      onPressed: () async {                    
                       final image = await screenshotController.captureFromWidget(const QrContainer());
                       saveImage(image); 
                      },
                      fontStyle: FontStyle.normal,
                    ),
                  ),

                  IconButton(
                    onPressed: ()async {
                      final image = await screenshotController.captureFromWidget(const QrContainer());
                      await shareImage(image);
                    }, 
                    icon: const Icon(Icons.share_rounded,size: 40,)
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: const FloatingButtonNavBarQr(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomMainAppBar(),
    );
  }
}

class QrContainer extends StatelessWidget {
  const QrContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 300,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 40, bottom: 40, left: 20, right: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: QrImageView(
            data: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            version: QrVersions.auto,
            size: 200.0,
            eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }
}

Future<String> saveImage(Uint8List bytes) async {
  await [Permission.storage].request();
  final time = DateTime.now()
    .toIso8601String()
    .replaceAll('.', '-')
    .replaceAll(':', '-');
  final name = "PaganiniQr_$time";
  final result = await ImageGallerySaver.saveImage(bytes,name: name);

  return result['filePath'];
}

Future shareImage(Uint8List bytes) async {
  final directory = await getTemporaryDirectory(); 
  final image = File('${directory.path}/temp_image.png'); 
  
  await image.writeAsBytes(bytes); // Guardar la imagen solo temporalmente

  // Compartir la imagen directamente desde los bytes
  await Share.shareXFiles([XFile(image.path)], text: 'Mi Qr de Paganini');

  // Eliminar el archivo temporal después de compartirlo
  await image.delete();
}
