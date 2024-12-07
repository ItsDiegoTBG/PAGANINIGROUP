import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';

class ButtonSecondVersion extends StatelessWidget {
  final String text;
  final Function function;
  final double verticalPadding;
  final double horizontalPadding;
  final Color backgroundColor;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? fontSize;

  const ButtonSecondVersion({
    super.key,
    required this.text,
    required this.function,
    this.backgroundColor = AppColors.secondaryColor,
    this.verticalPadding = 5,
    this.horizontalPadding = 30, this.buttonWidth, this.buttonHeight, this.fontSize
   
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: TextButton(
        onPressed: () {
          function();
        },
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center, // Centra el texto dentro del botón
            style:  TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: fontSize ?? 22,
            ),
          ),
        ),
      ),
    );
  }
}
