import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/router/app_routes.dart';
import '../config/themes/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fohar Malai',
      themeMode: ThemeMode.system,
      theme: MyAppTheme.lightTheme,
      darkTheme: MyAppTheme.darkTheme,
      //theme: AppTheme.getApplicationTheme(isDark: false),
      initialRoute: MyRoutes.preloginRoute,
      routes: MyRoutes.getApplicationRoute(),
      builder: EasyLoading.init(),
    );
  }
}