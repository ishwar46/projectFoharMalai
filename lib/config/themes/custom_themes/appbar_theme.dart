import 'package:care_app_flutter/config/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBarTheme {
  CustomAppBarTheme._();

//======LightMode======
  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.primaryColor,
    foregroundColor: AppColors.whiteText,
    iconTheme: IconThemeData(
      color: Colors.white,
      size: 24,
    ),
    surfaceTintColor: Colors.transparent,
    actionsIconTheme: IconThemeData(
      color: Colors.white,
      size: 24,
    ),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  //======DarkMode======

  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: Colors.white,
      size: 24,
    ),
    surfaceTintColor: Colors.transparent,
    actionsIconTheme: IconThemeData(
      color: Colors.white,
      size: 24,
    ),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );
}
