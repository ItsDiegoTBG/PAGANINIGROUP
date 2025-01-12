import 'dart:ffi';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';

class FloatingButtonPaganini extends StatelessWidget {
  final bool isQrPrincipal;
  final VoidCallback? onPressed;
  final IconData iconData;
  const FloatingButtonPaganini(
      {super.key, this.onPressed, required this.iconData,this.isQrPrincipal = false});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 2,
      onPressed: onPressed,
     // backgroundColor: AppColors.secondaryColor,
      child: isQrPrincipal ? SpinPerfect(
        infinite: true,
        duration: const Duration(seconds: 60),
        child: Icon(        
          iconData,size: 30,
        ),
      ) : Icon(iconData,size: 30,)
    );
  }
}
