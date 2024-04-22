import 'package:care_app_flutter/core/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/constants/app_colors.dart';
import '../../../config/constants/app_sizes.dart';

class PermissionHelper {
  static Future<void> requestLocationPermission(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.locationAlways,
    ].request();

    if (statuses[Permission.location] != PermissionStatus.granted &&
        statuses[Permission.locationWhenInUse] != PermissionStatus.granted &&
        statuses[Permission.locationAlways] != PermissionStatus.granted) {
      await _showPermissionBottomSheet(context);
    }
  }

  static Future<void> _showPermissionBottomSheet(BuildContext context) async {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    await showModalBottomSheet(
      backgroundColor: isDarkMode ? AppColors.dark : AppColors.whiteText,
      showDragHandle: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Location Permission Required!',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: 18,
                    ),
              ),
              SizedBox(height: AppSizes.sm),
              LottieBuilder(
                lottie: AssetLottie(
                  'assets/animations/no_location.json',
                ),
                width: 150,
                height: 150,
                repeat: true,
              ),
              SizedBox(height: AppSizes.sm),
              Text(
                'We cannot locate you. In order to use this app, please grant location permission.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: AppSizes.spaceBtwnInputFields),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    openAppSettings();
                  },
                  child: Text('Open Settings'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
