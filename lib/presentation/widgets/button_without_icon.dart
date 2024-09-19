import 'package:flutter/material.dart';
import 'package:paganini/utils/colors.dart';

class ButtonWithoutIcon extends StatelessWidget {
  final String text;
  final Function onPressed;
  const ButtonWithoutIcon({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      onPressed: () {
        onPressed();
      },
      child:  Text(
        text,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontStyle: FontStyle.italic),
      ),
    );
  }
}

