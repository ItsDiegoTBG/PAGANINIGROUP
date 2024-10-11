import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paganini/routes/app_pages.dart';
import 'package:paganini/utils/colors.dart';

class FloatingButtonNavBarQr extends StatelessWidget {
  const FloatingButtonNavBarQr({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: FloatingActionButton(
        elevation: 3,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          Get.toNamed(Routes.QRPAGE);
        },
        child: const Icon(
          Icons.qr_code,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
