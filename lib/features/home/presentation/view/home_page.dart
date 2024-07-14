import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foharmalai/features/payment/presentation/view/transaction_history_page.dart';
import 'package:foharmalai/features/settings/settings_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../core/common/widgets/custom_snackbar.dart';
import '../../../../core/utils/helpers/helper_functions.dart';
import '../../../dashboard/presentation/view/dashboard_page.dart';
import 'bottom_view/profile_page.dart';
import '../../../../app_localizations.dart';

class HomePageNew extends StatefulWidget {
  const HomePageNew({Key? key, this.firebaseToken}) : super(key: key);

  final String? firebaseToken;

  @override
  State<HomePageNew> createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final List _children = [
    const DashboardView(),
    TransactionHistoryPage(),
    const SettingsView(),
    ProfilePage(),
  ];

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool _isBackButtonDisabled = false;
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _isUserLoggedIn() async {
    final storedUsername = await secureStorage.read(key: "username");
    return storedUsername != null;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (_isBackButtonDisabled) {
            DateTime currentTime = DateTime.now();

            bool backButtonDelayPassed = _lastPressedAt == null ||
                currentTime.difference(_lastPressedAt!) > Duration(seconds: 2);

            if (backButtonDelayPassed) {
              _lastPressedAt = currentTime;

              showSnackBar(
                  message: localizations.translate('press_again_to_exit'),
                  context: context,
                  color: AppColors.warning);
            } else {}
          } else {
            _isBackButtonDisabled = true;
            DateTime currentTime = DateTime.now();
            _lastPressedAt = currentTime;

            showSnackBar(
                message: localizations.translate('press_again_to_exit'),
                context: context,
                color: AppColors.warning);
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Scaffold(
            body: Center(
              child: _children.elementAt(_currentIndex),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.dark : Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.1),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
                  child: GNav(
                    haptic: true,
                    rippleColor: AppColors.grey,
                    hoverColor: AppColors.grey,
                    gap: 5,
                    activeColor: isDarkMode
                        ? AppColors.primaryColor
                        : AppColors.primaryColor,
                    iconSize: 24,
                    textStyle: TextStyle(
                        color:
                            isDarkMode ? AppColors.primaryColor : Colors.black,
                        fontSize: 12.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor:
                        isDarkMode ? AppColors.white : Colors.white,
                    color: isDarkMode ? AppColors.white : Colors.black,
                    tabs: [
                      GButton(
                        icon: Iconsax.home,
                        text: localizations.translate('home'),
                      ),
                      GButton(
                        icon: Iconsax.receipt,
                        text: localizations.translate('statements'),
                      ),
                      GButton(
                        icon: Iconsax.settings,
                        text: localizations.translate('settings'),
                      ),
                      GButton(
                        icon: Iconsax.user,
                        text: localizations.translate('profile'),
                      ),
                    ],
                    selectedIndex: _currentIndex,
                    onTabChange: (index) async {
                      if (index != 0 && !await _isUserLoggedIn()) {
                        showSnackBar(
                            message: localizations.translate('login_required'),
                            context: context,
                            color: AppColors.error);
                      } else {
                        setState(() {
                          _currentIndex = index;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
