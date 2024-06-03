import 'package:flutter/material.dart';
import '../../../../app_localizations.dart';
import '../../../../config/constants/image_strings.dart';
import 'card_widget.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SizedBox(
              height: 110,
              child: CardWidgetPre(
                title: AppLocalizations.of(context).translate('waste_pickup'),
                routeName: "/hospital",
                imagePath: AppImages.cardImage1,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 110,
              child: CardWidgetPre(
                title: AppLocalizations.of(context).translate('sell'),
                routeName: "/appointment",
                imagePath: AppImages.cardImage2,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 110,
              child: CardWidgetPre(
                title: AppLocalizations.of(context).translate('donate'),
                routeName: "/appointment",
                imagePath: AppImages.cardImage3,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 110,
              child: CardWidgetPre(
                title: AppLocalizations.of(context).translate('blogs'),
                routeName: "/appointment",
                imagePath: AppImages.cardImage4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
