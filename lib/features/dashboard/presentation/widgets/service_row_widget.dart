import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../app_localizations.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../../core/common/widgets/custom_snackbar.dart';
import 'dashboard_card_widget.dart';

class ServiceRow extends StatelessWidget {
  const ServiceRow({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  final bool isDarkMode;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<bool> _isUserLoggedIn() async {
    final storedUsername = await secureStorage.read(key: "username");
    return storedUsername != null;
  }

  void _showLoginRequiredMessage(BuildContext context) {
    showSnackBar(
        message: 'You must login to use this feature.',
        context: context,
        color: AppColors.error);
  }

  void _navigateOrShowMessage(BuildContext context, String routeName) async {
    if (await _isUserLoggedIn()) {
      Navigator.pushNamed(context, routeName);
    } else {
      _showLoginRequiredMessage(context);
    }
  }

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
              onTap: () => Navigator.pushNamed(context, "/requestPickupRoute"),
            ),
          ),
          Container(
            width: 140,
            height: 100,
            padding: const EdgeInsets.all(10),
            child: DashboardCardWidget(
              title: localizations.translate("special_requests"),
              routeName: "/specialRequestRoute",
              imagePath: "assets/images/perks.png",
              isDarkMode: isDarkMode,
              onTap: () =>
                  _navigateOrShowMessage(context, "/specialRequestRoute"),
            ),
          ),
          Container(
            width: 140,
            height: 100,
            padding: const EdgeInsets.all(10),
            child: DashboardCardWidget(
              title: localizations.translate("locations"),
              routeName: "/dropPointRoute",
              imagePath: "assets/images/map.png",
              isDarkMode: isDarkMode,
              onTap: () => Navigator.pushNamed(context, "/dropPointRoute"),
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
              onTap: () => _navigateOrShowMessage(context, "/paymentRoute"),
            ),
          ),
        ],
      ),
    );
  }
}
