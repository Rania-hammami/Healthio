import 'package:flutter/material.dart';
import 'package:testflutterapp/src/presentation/utils/app_colors.dart';

class AppTheme {

  ThemeData lightThemeData = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primaryColor,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors().backgroundColor,
      indicatorColor: AppColors.primaryColor.withOpacity(0.1),
      surfaceTintColor: Colors.transparent,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondaryDarkColor,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(
        AppColors.secondaryLightColor.withOpacity(0.1),
      ),
      checkColor: MaterialStateProperty.all(
        AppColors.secondaryDarkColor,
      ),
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
    ),
    dialogTheme: const DialogTheme(
      surfaceTintColor: Colors.transparent,
    ),
  );

  ThemeData darkThemeData = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors().backgroundColor,
    primaryColor: AppColors.primaryColor,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors().backgroundColor,
      indicatorColor: AppColors.primaryColor.withOpacity(0.1),
      surfaceTintColor: Colors.transparent,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondaryDarkColor,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(
        AppColors.secondaryLightColor.withOpacity(0.1),
      ),
      checkColor: MaterialStateProperty.all(
        AppColors.secondaryDarkColor,
      ),
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
    ),
    dialogTheme: const DialogTheme(
      surfaceTintColor: Colors.transparent,
    ),
  );
}