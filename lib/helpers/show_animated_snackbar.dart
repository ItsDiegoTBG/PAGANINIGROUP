import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

class ShowAnimatedSnackBar {
  static void show(
      BuildContext context, String text, IconData icon, Color color) {
    AnimatedSnackBar(
      duration: const Duration(seconds: 2),
      builder: ((context) {
        return MaterialAnimatedSnackBar(
          iconData: icon,
          messageText: text,
          type: AnimatedSnackBarType.error,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          backgroundColor: color,
          titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 10,
          ),
        );
      }),
    ).show(context);
  }
}
