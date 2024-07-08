import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/constants/app_colors.dart';

class DashboardCardWidget extends StatelessWidget {
  final String title;
  final String routeName;
  final String imagePath;
  final bool isDarkMode;
  final VoidCallback onTap;

  const DashboardCardWidget({
    Key? key,
    required this.title,
    required this.routeName,
    required this.imagePath,
    required this.isDarkMode,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  colors: [AppColors.darkModeOnPrimary, AppColors.dark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isDarkMode ? null : AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black54 : Colors.grey.shade300,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: isDarkMode
                            ? AppColors.whiteText
                            : AppColors.whiteText,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
