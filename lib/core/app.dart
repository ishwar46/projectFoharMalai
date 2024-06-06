import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../config/router/app_routes.dart';
import '../config/themes/app_theme.dart';
import 'common/provider/language_service.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();

  static _AppState? _instance;

  static _AppState get instance {
    assert(_instance != null,
        'Attempted to access App.instance before it was initialized.');
    return _instance!;
  }

  static void setInstance(_AppState instance) {
    _instance = instance;
  }
}

class _AppState extends ConsumerState<App> {
  Locale _locale = Locale('en');

  @override
  void initState() {
    super.initState();
    App.setInstance(this);
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    LanguageService languageService = LanguageService();
    String? languageCode = await languageService.getLanguageCode();
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode);
      });
    }
  }

  void setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    LanguageService languageService = LanguageService();
    await languageService.saveLanguageCode(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fohar Malai',
      themeMode: ThemeMode.system,
      theme: MyAppTheme.lightTheme,
      darkTheme: MyAppTheme.darkTheme,
      initialRoute: MyRoutes.homePageRoute,
      routes: MyRoutes.getApplicationRoute(),
      builder: EasyLoading.init(),
      locale: _locale,
      supportedLocales: [
        Locale('en', ''),
        Locale('es', ''),
        Locale('ne', ''),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
