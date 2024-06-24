import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../config/router/app_routes.dart';
import '../../../../../config/constants/image_strings.dart';

import '../../core/utils/helpers/helper_functions.dart';
import '../../core/utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late SizeConfig screen;

  @override
  void initState() {
    super.initState();
    screen = SizeConfig();
    checkTokenValidity();
  }

  void checkTokenValidity() async {
    // Read the token from secure storage
    final String? token = await secureStorage.read(key: "authToken");

    // Simulate loading process with a delay
    await Future.delayed(const Duration(seconds: 3));

    // Check if the token is valid and not expired
    if (token != null && !JwtDecoder.isExpired(token)) {
      Navigator.pushReplacementNamed(context, MyRoutes.homePageRoute);
    } else {
      Navigator.pushReplacementNamed(context, MyRoutes.preloginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    screen.init(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElasticIn(
              duration: const Duration(seconds: 2),
              child: Hero(
                tag: 'logo',
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    dark ? AppImages.darkAppLogo : AppImages.lightAppLogo,
                    height: screen.screenWidth / 1,
                    width: screen.screenWidth / 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
