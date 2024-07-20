import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  ThemeMode _themeMode = ThemeMode.system; // Add this line

  @override
  void initState() {
    super.initState();
    App.setInstance(this);
    _loadLocale();
    _loadThemeMode();
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

  Future<void> _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('themeMode');
    setState(() {
      if (theme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else if (theme == 'light') {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode = ThemeMode.system;
      }
    });
  }

  void setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    LanguageService languageService = LanguageService();
    await languageService.saveLanguageCode(locale.languageCode);
  }

  void setThemeMode(ThemeMode themeMode) async {
    setState(() {
      _themeMode = themeMode;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeMode.toString().split('.').last);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fohar Malai',
      themeMode: _themeMode,
      theme: MyAppTheme.lightTheme,
      darkTheme: MyAppTheme.darkTheme,
      initialRoute: MyRoutes.splashRoute,
      routes: MyRoutes.getApplicationRoute(),
      builder: EasyLoading.init(),
      locale: _locale,
      supportedLocales: [
        Locale('en', ''),
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
