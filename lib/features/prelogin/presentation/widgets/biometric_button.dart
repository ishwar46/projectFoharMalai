import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../core/utils/helpers/helper_functions.dart';

class Biometric extends StatelessWidget {
  const Biometric({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    return SizedBox(
      child: ElevatedButton(
        onPressed: () {
          //Navigator.pushNamed(context, MyRoutes.smoothpage);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          shape: const RoundedRectangleBorder(
            // side: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          elevation: 2,
          splashFactory: InkRipple.splashFactory,
          backgroundColor:
              isDarkMode ? AppColors.darkModeOnPrimary : AppColors.primaryColor,
        ),
        child: const Icon(
          Iconsax.finger_scan,
          size: 20,
        ),
      ),
    );
  }
}
