import 'package:flutter/material.dart';

import '../../../../config/constants/text_strings.dart';
import '../../../../config/router/app_routes.dart';

class PreLoginButton extends StatelessWidget {
  const PreLoginButton({
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
            AppTexts.login.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
