import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:paganini/helpers/show_qr.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/core/device/qr_code_scanner.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/widgets/qr_container.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
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
    final userProviderWatch = context.watch<UserProvider>();
    final qrContainer = QrContainer(data: userProviderWatch.currentUser?.id);
    final userName = userProviderWatch.currentUser?.firstname ?? "Usuario no disponible";
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Image.asset(
                  "assets/image/paganini_logo_horizontal_morado.png"),
            ),
          ),
          GestureDetector(
            onTap: (){
              ShowQr.showQrDialog(context, qrContainer, userName);
            },
              child: const Icon(
            Icons.zoom_in,
            size: 30,
            color: AppColors.primaryColor,
          )),
          //Text(_result ?? 'No result'),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  debugPrint("QR TAP");
                  debugPrint("Se dio click en el Qr");
                   ShowQr.showQrDialog(context, qrContainer, userName);
                },
                child: Center(
                  child: Screenshot(
                      controller: screenshotController, child: qrContainer),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.save_rounded,
                      size: 40,
                    ),
                    onPressed: () async {
                      final image = await screenshotController
                          .captureFromWidget(qrContainer);
                      // ignore: use_build_context_synchronously
                      await saveImage(image, context);
                    },
                  ),
                  IconButton(
                      onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  QrCodeScanner(setResult: setResult),
                            ),
                          ),
                      icon: const Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 60,
                        color: AppColors.primaryColor,
                      )),
                  IconButton(
                      onPressed: () async {
                        final image = await screenshotController
                            .captureFromWidget(qrContainer);
                        await shareImage(image);
                      },
                      icon: const Icon(
                        Icons.share_rounded,
                        size: 40,
                      )),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

Future<String> saveImage(Uint8List bytes, context) async {
  await [Permission.storage].request();
  final time = DateTime.now()
      .toIso8601String()
      .replaceAll('.', '-')
      .replaceAll(':', '-');
  final name = "PaganiniQr_$time";
  final result = await ImageGallerySaver.saveImage(bytes, name: name);

  if (result['filePath'] != null) {
    AnimatedSnackBar(
      duration: const Duration(seconds: 3),
      builder: ((context) {
        return const MaterialAnimatedSnackBar(
          iconData: Icons.check,
          messageText: 'El QR se guardo correctamente',
          type: AnimatedSnackBarType.success,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          backgroundColor: Color.fromARGB(255, 59, 141, 55),
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 10,
          ),
        );
      }),
    ).show(context);
  } else {}

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
