import 'package:flutter/widgets.dart';

import '../../../../config/constants/image_strings.dart';
import 'card_widget.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SizedBox(
              height: 110,
              //padding: const EdgeInsets.all(5),
              child: CardWidgetPre(
                title: "Waste Pickup",
                routeName: "/hospital",
                imagePath: AppImages.cardImage1,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 110,
              //padding: const EdgeInsets.all(10),
              child: CardWidgetPre(
                title: "Sell",
                routeName: "/appointment",
                imagePath: AppImages.cardImage2,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 110,
              //padding: const EdgeInsets.all(10),
              child: CardWidgetPre(
                title: "Donate",
                routeName: "/appointment",
                imagePath: AppImages.cardImage3,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 110,
              //padding: const EdgeInsets.all(10),
              child: CardWidgetPre(
                title: "Blogs",
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
