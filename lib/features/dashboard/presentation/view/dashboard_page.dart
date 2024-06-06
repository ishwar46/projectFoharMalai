import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

import '../../../../../config/constants/app_colors.dart';
import '../../../../../config/router/app_routes.dart';
import '../../../../../core/utils/helpers/helper_functions.dart';
import '../../../../app_localizations.dart';
import '../widgets/alert_text_widget.dart';
import '../widgets/notification_card_widget.dart';
import '../widgets/service_row_widget.dart';
import '../widgets/service_text_widget.dart';
import '../widgets/upcoming_schedule_widget.dart';
import '../widgets/what_we_buy.dart';
import '../widgets/what_we_buy_text.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String? username;

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    final storedUsername = await secureStorage.read(key: "username");
    setState(() {
      username = storedUsername;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: AppLocalizations.of(context).translate("logout"),
      titleTextStyle: GoogleFonts.montserrat(
        color: AppColors.primaryColor,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      desc: AppLocalizations.of(context).translate("logout_confirmation"),
      btnCancelOnPress: () {},
      btnOkOnPress: () => logout(context),
    ).show();
  }

  Future<void> logout(BuildContext context) async {
    await secureStorage.delete(key: "authToken");
    Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);
    final appBarTitle = username == null
        ? localizations.translate("welcome_guest")
        : localizations
            .translate("welcome_user")
            .replaceAll("{username}", username!);

    final locale = Localizations.localeOf(context);
    String formattedDate;
    if (locale.languageCode == 'ne') {
      final nepaliDate = NepaliDateTime.now();
      formattedDate = NepaliDateFormat('EEEE, d MMMM y').format(nepaliDate);
    } else {
      formattedDate = DateFormat('EEEE, d MMM y').format(DateTime.now());
    }
    final today =
        localizations.translate("today_is").replaceAll("{date}", formattedDate);

    return PopScope(
      canPop: false,
      onPopInvoked: (_) async {
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? AppColors.dark : AppColors.whiteText,
        appBar: _buildAppBar(context, isDarkMode, appBarTitle, today),
        body: _buildBody(context, isDarkMode),
      ),
    );
  }

  AppBar _buildAppBar(
      BuildContext context, bool isDarkMode, String appBarTitle, String today) {
    return AppBar(
      backgroundColor: isDarkMode ? AppColors.dark : AppColors.light,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appBarTitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: GoogleFonts.roboto(
              color: AppColors.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            today,
            style: GoogleFonts.roboto(
              color: AppColors.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Iconsax.menu, color: AppColors.primaryColor),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: _buildAppBarActions(context),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        color: AppColors.primaryColor,
        icon: const Icon(Icons.notifications),
        onPressed: () {
          Navigator.pushNamed(context, MyRoutes.viewNotificationRoute);
        },
      ),
      IconButton(
        color: AppColors.primaryColor,
        icon: Icon(MdiIcons.faceAgent),
        onPressed: () {
          Navigator.pushNamed(context, MyRoutes.viewNotificationRoute);
        },
      ),
      IconButton(
        color: AppColors.error,
        icon: const Icon(Icons.logout),
        onPressed: () {
          _showLogoutDialog(context);
        },
      ),
    ];
  }

  Widget _buildBody(BuildContext context, bool isDarkMode) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: ServiceRow(isDarkMode: isDarkMode),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: ServiceText(isDarkMode: isDarkMode),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: UpComingWidget(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: WhatWeBuyText(isDarkMode: isDarkMode),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: WhatWeBuyWidget(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: AlertText(isDarkMode: isDarkMode),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: AlertCard(),
            ),
          ],
        ),
      ),
    );
  }
}
