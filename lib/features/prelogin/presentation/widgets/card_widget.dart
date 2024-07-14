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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [AppColors.darkModeOnPrimary, AppColors.dark]
              : [AppColors.whiteText, AppColors.whiteText],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black54 : Colors.grey.shade300,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        enableFeedback: true,
        onTap: () {
          EasyLoading.showInfo(
              "Please Login or Entry as Guest to use this feature.");
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: isDarkMode ? AppColors.whiteText : Colors.black,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
