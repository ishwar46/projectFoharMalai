import 'package:flutter/material.dart';
import 'package:foharmalai/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertText extends StatelessWidget {
  const AlertText({Key? key, required this.isDarkMode}) : super(key: key);

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              localizations.translate('notifications'),
              style: GoogleFonts.roboto(
                color:
                    isDarkMode ? Colors.white : Theme.of(context).primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          //View All
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              localizations.translate('view_all'),
              style: GoogleFonts.roboto(
                color:
                    isDarkMode ? Colors.white : Theme.of(context).primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
