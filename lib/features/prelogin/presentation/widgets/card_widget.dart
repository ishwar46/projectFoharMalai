import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../core/utils/helpers/helper_functions.dart';

class CardWidgetPre extends StatelessWidget {
  final String title;
  final String routeName;
  final String imagePath;

  const CardWidgetPre({
    super.key,
    required this.title,
    required this.routeName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    return Card(
      surfaceTintColor:
          isDarkMode ? AppColors.darkModeOnPrimary : AppColors.whiteText,
      color: isDarkMode ? AppColors.darkModeOnPrimary : AppColors.whiteText,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: InkWell(
        enableFeedback: true,
        onTap: () {
          EasyLoading.showInfo("This feature is coming soon.");
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 40,
              width: 40,
              //color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.0,
                color: Theme.of(context).textTheme.bodyMedium!.color,
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
