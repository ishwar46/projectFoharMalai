import 'package:care_app_flutter/config/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField {
  CustomTextFormField._();

  //=====Light Mode Input Decoration Theme
  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    constraints: BoxConstraints.expand(height: 55),
    labelStyle: const TextStyle().copyWith(
      fontSize: 12,
      color: Colors.black,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 12,
      color: AppColors.primaryTextColor,
    ),
    errorStyle: const TextStyle().copyWith(
      fontStyle: FontStyle.normal,
    ),
    floatingLabelStyle:
        const TextStyle().copyWith(color: Colors.black.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 1, color: AppColors.primaryColor),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 2, color: Colors.orange),
    ),
  );

  //======Dark Mode Input Decoration Theme

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    constraints: BoxConstraints.expand(height: 55),
    labelStyle: const TextStyle().copyWith(
      fontSize: 12,
      color: Colors.white,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 12,
      color: Colors.white,
    ),
    floatingLabelStyle:
        TextStyle().copyWith(color: Colors.white.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 1, color: Colors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 2, color: Colors.orange),
    ),
  );
}
