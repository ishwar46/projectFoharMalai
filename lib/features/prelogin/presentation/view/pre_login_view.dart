import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:card_swiper/card_swiper.dart';
import '../../../../app_localizations.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/image_strings.dart';
import '../../../../core/app.dart';
import '../../../../core/common/provider/biometric_provider.dart';
import '../../../../core/common/provider/language_service.dart';
import '../../../../core/common/widgets/explore_more_btn.dart';
import '../../../../core/utils/helpers/helper_functions.dart';
import '../widgets/biometric_button.dart';
import '../widgets/services_card_widget.dart';
import '../widgets/vertical_card.dart';

class PreLoginPage extends ConsumerStatefulWidget {
  const PreLoginPage({super.key});

  @override
  _PreLoginPageState createState() => _PreLoginPageState();
}

class _PreLoginPageState extends ConsumerState<PreLoginPage> {
  final List<String> images = List.filled(3, 'assets/images/donate.png');

  String? appName;
  String? version;
  final LanguageService languageService = LanguageService();

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  Future<void> _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      version = packageInfo.version;
    });
  }

  void _changeLanguage(Locale locale) async {
    App.instance.setLocale(locale);
    await languageService.saveLanguageCode(locale.languageCode);
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: false,
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
                leading: CountryCodePicker(
                  onInit: (_) {},
                  initialSelection: 'US',
                  showCountryOnly: true,
                  showOnlyCountryWhenClosed: true,
                  alignLeft: true,
                  hideMainText: true,
                ),
                title: const Text('English'),
                onTap: () {
                  _changeLanguage(Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CountryCodePicker(
                  onInit: (_) {},
                  initialSelection: 'np',
                  showCountryOnly: true,
                  showOnlyCountryWhenClosed: true,
                  alignLeft: true,
                  hideMainText: true,
                ),
                title: const Text('Nepali'),
                onTap: () {
                  _changeLanguage(Locale('ne'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: CountryCodePicker(
                  onInit: (_) {},
                  initialSelection: 'ES',
                  showCountryOnly: true,
                  showOnlyCountryWhenClosed: true,
                  alignLeft: true,
                  hideMainText: true,
                ),
                title: const Text('Español'),
                onTap: () {
                  _changeLanguage(Locale('es'));
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
    final isDark = HelperFunctions.isDarkMode(context);
    final isBiometricVisible = ref.watch(biometricProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: isDark ? AppColors.dark : AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: isDark ? AppColors.dark : AppColors.whiteText,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.dark : AppColors.whiteText,
          toolbarHeight: 70,
          leadingWidth: 100,
          leading: Hero(
            tag: 'logo',
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                height: 180,
                image: AssetImage(
                    isDark ? AppImages.darkAppLogo : AppImages.lightAppLogo),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.translate,
                color: isDark ? AppColors.whiteText : AppColors.primaryColor,
              ),
              onPressed: () => _showLanguageBottomSheet(context),
            ),
            const ExploreMoreButton(),
            const SizedBox(width: 20),
            if (isBiometricVisible) ...[
              const Biometric(),
              const SizedBox(width: 15),
            ],
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Swiper.children(
                      curve: Curves.easeInOut,
                      autoplay: true,
                      duration: 1000,
                      children: images
                          .map((imagePath) => Image.asset(
                                imagePath,
                                fit: BoxFit.fill,
                              ))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('our_services'),
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppColors.whiteText : AppColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const ServicesCard(),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('articles'),
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppColors.whiteText : AppColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(height: 200, child: NewsSlider()),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
