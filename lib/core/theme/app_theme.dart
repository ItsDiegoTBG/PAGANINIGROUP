import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';

class AppTheme {
  final List<Color> _colors = [
    AppColors.primaryColor,
    AppColors.secondaryColor,
    Colors.black,
    Colors.purple,
  ];

  ThemeData? theme() {
    return ThemeData(useMaterial3: true, colorSchemeSeed: _colors[0],scaffoldBackgroundColor: Colors.white,bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.primaryColor),appBarTheme: const AppBarTheme(color: Colors.white));
  }
}

/*
theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.white),
          scaffoldBackgroundColor: Colors.white*/