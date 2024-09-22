import 'package:flutter/material.dart';
import 'package:paganini/utils/colors.dart';

class ButtonSecondVersion extends StatelessWidget {
  final String text;
  const ButtonSecondVersion({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          backgroundColor: AppColors.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      child:  Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
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