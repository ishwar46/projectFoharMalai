import 'package:flutter/material.dart';

class CustomTextTheme {
  CustomTextTheme._();

  //=======Light TextTheme==========
  static TextTheme lightTextTheme = TextTheme(
    //Headlines
    headlineLarge: const TextStyle().copyWith(
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: 10.0,
      fontWeight: FontWeight.w300,
      color: Colors.black,
    ),

    //Titles
    titleLarge: const TextStyle().copyWith(
      fontSize: 15.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 15.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),

    //Body
    bodyLarge: const TextStyle().copyWith(
      fontSize: 13.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 13.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 10.0,
      fontWeight: FontWeight.w500,
      color: Colors.black.withOpacity(0.5),
    ),

    //label
    labelLarge: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.black.withOpacity(0.5),
    ),
  );

  //=======Dark TextTheme==========
  static TextTheme darkTextTheme = TextTheme(
    //Headlines
    headlineLarge: const TextStyle().copyWith(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: 10.0,
      fontWeight: FontWeight.w300,
      color: Colors.white,
    ),

    //Titles
    titleLarge: const TextStyle().copyWith(
      fontSize: 15.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 15.0,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),

    //body
    bodyLarge: const TextStyle().copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 13.0,
      fontWeight: FontWeight.w500,
      color: Colors.white.withOpacity(0.5),
    ),

    //label
    labelLarge: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.white.withOpacity(0.5),
    ),
  );
}
