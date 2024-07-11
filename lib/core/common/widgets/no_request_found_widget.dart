import 'package:flutter/material.dart';
import 'package:foharmalai/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/constants/app_colors.dart';

class NoRequestFoundWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String noRequestText;
  final String lottieAnimationPath;

  const NoRequestFoundWidget({
    Key? key,
    required this.onRetry,
    required this.noRequestText,
    required this.lottieAnimationPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            lottieAnimationPath,
            width: 250,
            height: 250,
          ),
          SizedBox(height: 16),
          Text(
            noRequestText,
            style: GoogleFonts.roboto(
              color: AppColors.error,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh),
              label: Text(
                localizations.translate('retry'),
                style: GoogleFonts.roboto(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
