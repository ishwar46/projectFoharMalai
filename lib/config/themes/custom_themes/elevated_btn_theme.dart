import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CustomElevatedButtonTheme {
  CustomElevatedButtonTheme._();

  //======Light Theme=====

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        disabledBackgroundColor: Colors.grey,
        disabledForegroundColor: Colors.grey,
        // side: const BorderSide(
        //   color: Color.fromARGB(255, 12, 69, 117),
        // ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
  );

  //=====Dark Theme ======

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.primaryColor,
      backgroundColor: AppColors.white,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.grey,
      // side: const BorderSide(
      //   color: Color.fromARGB(255, 12, 69, 117),
      // ),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
  );
}
