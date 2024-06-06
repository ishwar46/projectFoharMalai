import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WhatWeBuyText extends StatelessWidget {
  const WhatWeBuyText({Key? key, required this.isDarkMode}) : super(key: key);

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              "What We Buy?",
              style: GoogleFonts.roboto(
                color:
                    isDarkMode ? Colors.white : Theme.of(context).primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
