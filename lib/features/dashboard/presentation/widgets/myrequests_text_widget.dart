import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app_localizations.dart';

class MyRequestsTexts extends StatelessWidget {
  const MyRequestsTexts({Key? key, required this.isDarkMode}) : super(key: key);

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
              localizations.translate("my_requests"),
              style: GoogleFonts.roboto(
                color:
                    isDarkMode ? Colors.white : Theme.of(context).primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/pickupListRoute');
              },
              child: Text(
                localizations.translate('view_all'),
                style: GoogleFonts.roboto(
                  color: isDarkMode
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
