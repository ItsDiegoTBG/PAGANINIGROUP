import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/button_without_icon.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';
import 'package:paganini/presentation/widgets/qr_code_scanner.dart';
import 'package:paganini/utils/colors.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  String? _result;
  final ScreenshotController screenshotController = ScreenshotController();

  void setResult(String result) {
    setState(() => _result = result);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Container(
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
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
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
                  const SizedBox(
                    width: 25,
                  ),
                  ButtonWithoutIcon(
                    text: "Guardar Qr",
                    onPressed: (){},
                    fontStyle: FontStyle.normal,
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
