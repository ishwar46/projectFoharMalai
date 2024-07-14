import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/router/app_routes.dart';
import '../../../app_localizations.dart';

class ExploreMoreButton extends StatelessWidget {
  const ExploreMoreButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Hero(
        tag: 'loginbutton',
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, MyRoutes.loginRoute);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            elevation: 2,
            splashFactory: InkRipple.splashFactory,
          ),
          child: Text(
              AppLocalizations.of(context).translate('login').toUpperCase(),
              style: GoogleFonts.roboto(
                fontSize: 12,
              )),
        ),
      ),
    );
  }
}
