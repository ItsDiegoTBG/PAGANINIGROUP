import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';

class AppTheme {
  final List<Color> _colors = [
    AppColors.primaryColor,
    AppColors.secondaryColor,
    Colors.black,
    Colors.purple,
  ];

  ThemeData themeLightMode() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colors[0],
      scaffoldBackgroundColor: Colors.white,
      bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.primaryColor),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.secondaryColor,
          foregroundColor: Colors.black),
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.grey[800]),
    );
  }

  ThemeData themeDarkMode() {
    return ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _colors[2],
        scaffoldBackgroundColor: Colors.black,
        bottomAppBarTheme:
            const BottomAppBarTheme(color: AppColors.primaryColor),
        appBarTheme:  const AppBarTheme(backgroundColor: Colors.black),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.white, foregroundColor: Colors.black),
        brightness: Brightness.dark,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ));
  }
}

/*
theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.white),
          scaffoldBackgroundColor: Colors.white*/