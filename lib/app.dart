import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/core/routes/app_routes_helper.dart';
import 'package:mega_news/core/theme/app_theme.dart';
import 'package:mega_news/generated/l10n.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // Fix Get.snackbar overlay
      builder: (context, child) =>
          Overlay(initialEntries: [OverlayEntry(builder: (context) => child!)]),

      // localization
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,

      // theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,

      // routes
      initialRoute: AppRoutesHelper.getInitialRoute(),
      getPages: AppPages.routes,
    );
  }
}
