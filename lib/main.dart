import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/constants/app_colors.dart';
import 'core/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  await dotenv.load(fileName: "assets/.env");
  configLoading();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ripple
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = AppColors.black
    ..indicatorColor = AppColors.whiteText
    ..textColor = Colors.white
    ..maskType = EasyLoadingMaskType.clear
    ..maskColor = Colors.transparent
    ..errorWidget = const Icon(
      Icons.cancel,
      color: AppColors.error,
      size: 40,
    )
    ..successWidget = const Icon(
      Icons.check,
      color: AppColors.success,
      size: 40,
    )
    ..textStyle = const TextStyle(
      color: Colors.white,
    )
    ..infoWidget = const Icon(
      Icons.info,
      color: AppColors.warning,
      size: 40,
    )
    ..userInteractions = false
    ..fontSize = 12
    ..indicatorSize = 30.0
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..toastPosition = EasyLoadingToastPosition.bottom;
}
