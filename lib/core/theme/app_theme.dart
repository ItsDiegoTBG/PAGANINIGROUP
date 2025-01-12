import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';

class AppTheme {

 ThemeData themeLightMode() {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      useMaterial3: true,
     // colorSchemeSeed: AppColors.primaryColor,
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
        primaryColor: Colors.white,
        useMaterial3: true,
       // colorSchemeSeed: Colors.black,
        scaffoldBackgroundColor: Colors.grey[900],
        bottomAppBarTheme:
            const BottomAppBarTheme(color: AppColors.primaryColor),
        appBarTheme:  const AppBarTheme(backgroundColor: Colors.black),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor:AppColors.secondaryColor, foregroundColor: Colors.black),
        brightness: Brightness.dark,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ));
  }
}