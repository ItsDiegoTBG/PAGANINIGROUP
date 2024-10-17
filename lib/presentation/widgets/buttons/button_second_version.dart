import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';

class ButtonSecondVersion extends StatelessWidget {
  final String text;
  final Function function;
  final double verticalPadding;
  final double horizontalPadding;
  const ButtonSecondVersion({
    super.key,
    required this.text,
    required this.function,
    this.verticalPadding = 5,
    this.horizontalPadding = 30,
  });

  @override
  Widget build(BuildContext context) {

    return TextButton(
      onPressed: () {
        function();
      },
      style: TextButton.styleFrom(
          backgroundColor: AppColors.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      child:  Padding(
        padding:
            EdgeInsets.symmetric(vertical: verticalPadding,horizontal:horizontalPadding),
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 22),
        ),
      ),
    );
  }
}