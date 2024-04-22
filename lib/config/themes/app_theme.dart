import 'package:care_app_flutter/config/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'custom_themes/appbar_theme.dart';
import 'custom_themes/bottom_sheet_theme.dart';
import 'custom_themes/check_box_theme.dart';
import 'custom_themes/chip_theme.dart';
import 'custom_themes/elevated_btn_theme.dart';
import 'custom_themes/outlined_btn_theme.dart';
import 'custom_themes/text_form_field_theme.dart';
import 'custom_themes/text_theme.dart';

class MyAppTheme {
  MyAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.whiteText,
    textTheme: CustomTextTheme.lightTextTheme,
    chipTheme: CustomChipTheme.lightChipTheme,
    appBarTheme: CustomAppBarTheme.lightAppBarTheme,
    checkboxTheme: CustomCheckBoxTheme.lightCheckboxTheme,
    bottomSheetTheme: CustomBottomSheetTheme.lightBottomSheetTheme,
    inputDecorationTheme: CustomTextFormField.lightInputDecorationTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: CustomOutlinedThemeButton.lightOutlinedButtonTheme,
  );

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.dark,
      textTheme: CustomTextTheme.darkTextTheme,
      chipTheme: CustomChipTheme.darkChipTheme,
      appBarTheme: CustomAppBarTheme.darkAppBarTheme,
      checkboxTheme: CustomCheckBoxTheme.darkCheckboxTheme,
      bottomSheetTheme: CustomBottomSheetTheme.darkBottomSheetTheme,
      inputDecorationTheme: CustomTextFormField.darkInputDecorationTheme,
      elevatedButtonTheme: CustomElevatedButtonTheme.darkElevatedButtonTheme,
      outlinedButtonTheme: CustomOutlinedThemeButton.darkOutlinedButtonTheme);
}
