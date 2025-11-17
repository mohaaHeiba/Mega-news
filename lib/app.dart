import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/route_manager.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/core/theme/app_theme.dart';
import 'package:mega_news/generated/l10n.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // because flutter upgrade i hate this version
      // Fix for Flutter upgrade issue: Get.snackbar() can't find an Overlay.
      // Adding a manual Overlay here restores normal GetX snackbar behavior.
      builder: (context, child) {
        return Overlay(
          initialEntries: [OverlayEntry(builder: (context) => child!)],
        );
      },

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
      initialRoute: AppPages.welcomePage,
      getPages: AppPages.routes,
    );
  }
}
