import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app_localizations.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../../core/app.dart';
import '../../../../core/common/provider/biometric_provider.dart';
import '../../../../core/common/provider/language_service.dart';
import '../../../../core/utils/helpers/helper_functions.dart';
import '../../core/common/widgets/custom_snackbar.dart';
import '../auth/presentation/view/login_page.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final LanguageService languageService = LanguageService();
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('themeMode');
    setState(() {
      isDarkMode = theme == 'dark';
    });
  }

  void _changeLanguage(Locale locale) async {
    App.instance.setLocale(locale);
    await languageService.saveLanguageCode(locale.languageCode);
  }

  void _changeThemeMode(bool value) {
    if (value) {
      App.instance.setThemeMode(ThemeMode.dark);
    } else {
      App.instance.setThemeMode(ThemeMode.light);
    }
    setState(() {
      isDarkMode = value;
    });
    EasyLoading.showSuccess(
      value
          ? AppLocalizations.of(context).translate("dark_mode_enabled")
          : AppLocalizations.of(context).translate("dark_mode_disabled"),
      duration: const Duration(seconds: 2),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).translate('choose_language'),
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(AppLocalizations.of(context).translate('english')),
                onTap: () {
                  _changeLanguage(Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context).translate('nepali')),
                onTap: () {
                  _changeLanguage(Locale('ne'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.dark : AppColors.whiteText,
      appBar: _buildAppBar(isDarkMode, theme, localizations),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            _buildSettingsGroup(localizations),
            _buildAboutSettingsGroup(localizations),
            _buildAccountSettingsGroup(localizations),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(
      bool isDarkMode, ThemeData theme, AppLocalizations localizations) {
    return AppBar(
      backgroundColor: isDarkMode ? AppColors.dark : AppColors.primaryColor,
      title: Text(
        localizations.translate("settings"),
        style: TextStyle(
          color: isDarkMode ? AppColors.whiteText : AppColors.white,
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      automaticallyImplyLeading: false,
    );
  }

  SettingsGroup _buildSettingsGroup(AppLocalizations localizations) {
    return SettingsGroup(
      items: [
        SettingsItem(
          onTap: () => _showLanguageBottomSheet(context),
          icons: CupertinoIcons.pencil_outline,
          iconStyle: IconStyle(
            backgroundColor: Colors.blue.shade900,
          ),
          title: localizations.translate('choose_language'),
          subtitle:
              "${localizations.translate('english')}, ${localizations.translate('nepali')}",
          backgroundColor: Colors.blue.shade900,
        ),
        SettingsItem(
          onTap: () {},
          icons: Icons.fingerprint,
          iconStyle: IconStyle(
            iconsColor: Colors.white,
            withBackground: true,
            backgroundColor: Colors.red,
          ),
          title: localizations.translate('privacy'),
          subtitle: localizations.translate('privacy_data_permissions'),
        ),
        SettingsItem(
          onTap: () {},
          icons: Icons.dark_mode_rounded,
          title: localizations.translate('dark_mode'),
          subtitle: localizations.translate('theme_mode'),
          trailing: Switch.adaptive(
            value: isDarkMode,
            onChanged: _changeThemeMode,
          ),
        ),
        SettingsItem(
          onTap: () {},
          icons: Icons.face,
          iconStyle: IconStyle(
            iconsColor: Colors.white,
            withBackground: true,
            backgroundColor: Colors.blue.shade900,
          ),
          title: localizations.translate('biometric_login'),
          subtitle:
              localizations.translate('login_with_fingerprint_or_face_id'),
          trailing: Consumer(
            builder: (context, ref, _) {
              final isBiometricEnabled = ref.watch(biometricProvider);
              return Switch.adaptive(
                value: isBiometricEnabled,
                onChanged: (value) async {
                  ref
                      .read(biometricProvider.notifier)
                      .setBiometricEnabled(value);

                  EasyLoading.showSuccess(
                    value
                        ? localizations.translate("biometric_login_enabled")
                        : localizations.translate("biometric_login_disabled"),
                    duration: const Duration(seconds: 2),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  SettingsGroup _buildAboutSettingsGroup(AppLocalizations localizations) {
    return SettingsGroup(
      items: [
        SettingsItem(
          onTap: () {
            EasyLoading.showInfo(
              "${localizations.translate("app_version")}: 1.0.0\n${localizations.translate("developer")}: Ishwar Chaudhary",
              duration: const Duration(seconds: 3),
            );
          },
          icons: Icons.info_rounded,
          iconStyle: IconStyle(
            backgroundColor: Colors.purple,
          ),
          title: localizations.translate('about'),
          subtitle:
              "${localizations.translate("app_version")}, ${localizations.translate("developer")}",
        ),
      ],
    );
  }

  SettingsGroup _buildAccountSettingsGroup(AppLocalizations localizations) {
    return SettingsGroup(
      settingsGroupTitle: localizations.translate("account"),
      items: [
        SettingsItem(
          onTap: () {
            _logout(context, localizations);
          },
          icons: Icons.exit_to_app_rounded,
          title: localizations.translate("sign_out"),
        ),
        SettingsItem(
          onTap: () {
            showSnackBar(
              message: localizations.translate('feature_under_development'),
              context: context,
              color: AppColors.warning,
            );
          },
          icons: CupertinoIcons.repeat,
          title: localizations.translate("change_email"),
        ),
        SettingsItem(
          onTap: () {
            showSnackBar(
              message: localizations.translate('feature_under_development'),
              context: context,
              color: AppColors.warning,
            );
          },
          icons: CupertinoIcons.lock,
          title: localizations.translate("change_password"),
        ),
        SettingsItem(
          onTap: () {
            showSnackBar(
              message: localizations.translate('feature_under_development'),
              context: context,
              color: AppColors.warning,
            );
          },
          icons: CupertinoIcons.delete_solid,
          title: localizations.translate("delete_account"),
          titleStyle: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _logout(BuildContext context, AppLocalizations localizations) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      closeIcon: const Icon(Icons.close),
      title: localizations.translate('logout'),
      desc: localizations.translate('logout_confirmation'),
      btnCancelOnPress: () {},
      onDismissCallback: (type) {
        debugPrint('Dialog Dismiss from callback $type');
      },
      btnOkOnPress: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ),
          (route) => false,
        );
      },
    ).show();
  }
}
