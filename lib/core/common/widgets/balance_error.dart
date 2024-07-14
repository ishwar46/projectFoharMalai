import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foharmalai/config/constants/app_colors.dart';

class BalanceErrorWidget extends StatelessWidget {
  final String errorMessage;

  BalanceErrorWidget({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Error',
                style: GoogleFonts.roboto(
                  color: AppColors.whiteText,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                errorMessage,
                style: GoogleFonts.roboto(
                  color: AppColors.whiteText,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          Icon(
            Icons.error_outline,
            color: AppColors.whiteText,
            size: 30.0,
          ),
        ],
      ),
    );
  }
}
