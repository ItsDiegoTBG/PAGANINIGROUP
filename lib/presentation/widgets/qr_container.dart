import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QrContainer extends StatelessWidget {

  final String? data;
  
  const QrContainer({
    super.key,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
   
    return Container(
      height: 320,
      width:  320,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: QrImageView(
              
              data: data ?? "Id no existe",
              version: QrVersions.auto,
              // embeddedImage: const AssetImage('assets/image/paganini_icono_negro.png'),
              // embeddedImageStyle: const QrEmbeddedImageStyle(
              //   size: Size(80, 80),
              // ),
              dataModuleStyle: const QrDataModuleStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  dataModuleShape: QrDataModuleShape.square),
              size: 200.0,
              eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.circle,
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        ),
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  "assets/image/paganini_icono_negro.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}