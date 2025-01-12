import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';

class ButtonSecondVersionIcon extends StatelessWidget {
  final Function function;
  final String text;
  final IconData icon;
  final IconAlignment iconAlignment;
  final Color color;
  final double horizontalPadding;
  const ButtonSecondVersionIcon({
    super.key,
    required this.function,
    required this.text,
    required this.icon,
    required this.iconAlignment,
    this.color = AppColors.secondaryColor,
    this.horizontalPadding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        label: Padding(
          padding:  EdgeInsets.symmetric(vertical: 2, horizontal: horizontalPadding),
          child: Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22),
          ),
        ),
        onPressed: () => {function()},
        iconAlignment: iconAlignment,
        style: TextButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        icon: Icon(
          icon,
          color: Colors.black,
        ));
  }
}
