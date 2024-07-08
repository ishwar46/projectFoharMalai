import 'package:flutter/material.dart';
import '../../../../app_localizations.dart';
import 'dashboard_card_widget.dart';

class ServiceRow extends StatelessWidget {
  const ServiceRow({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 140,
            height: 100,
            padding: const EdgeInsets.all(10),
            child: DashboardCardWidget(
              title: localizations.translate("schedule_pickup"),
              routeName: "/requestPickupRoute",
              imagePath: "assets/images/garbage.png",
              isDarkMode: isDarkMode,
            ),
          ),
          Container(
            width: 140,
            height: 100,
            padding: const EdgeInsets.all(10),
            child: DashboardCardWidget(
              title: localizations.translate("special_requests"),
              routeName: "/speacialRequestRoute",
              imagePath: "assets/images/perks.png",
              isDarkMode: isDarkMode,
            ),
          ),
          Container(
            width: 140,
            height: 100,
            padding: const EdgeInsets.all(10),
            child: DashboardCardWidget(
              title: localizations.translate("locations"),
              routeName: "/pickupListRoute",
              imagePath: "assets/images/map.png",
              isDarkMode: isDarkMode,
            ),
          ),
          Container(
            width: 140,
            height: 100,
            padding: const EdgeInsets.all(10),
            child: DashboardCardWidget(
              title: localizations.translate("payments"),
              routeName: "/paymentRoute",
              imagePath: "assets/images/cash-payment.png",
              isDarkMode: isDarkMode,
            ),
          ),
        ],
      ),
    );
  }
}
