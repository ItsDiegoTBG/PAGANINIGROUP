import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';

class FloatingButtonPaganini extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData iconData;
  const FloatingButtonPaganini(
      {super.key, this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 2,
      onPressed: onPressed,
     // backgroundColor: AppColors.secondaryColor,
      child: Icon(
        iconData,
      ),
    );
  }
}
