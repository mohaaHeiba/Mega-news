import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum ThemeModeSelection { light, dark, system }

class ThemeController extends GetxController {
  final storage = GetStorage();
  final Rx<ThemeModeSelection> selectedMode = ThemeModeSelection.system.obs;

  final language = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
    loadLanguage();
  }

  // ==================== Theme Logic ====================
  void loadTheme() {
    final savedTheme = storage.read('savedTheme');
    switch (savedTheme) {
      case 'light':
        selectedMode.value = ThemeModeSelection.light;
        Get.changeThemeMode(ThemeMode.light);
        break;
      case 'dark':
        selectedMode.value = ThemeModeSelection.dark;
        Get.changeThemeMode(ThemeMode.dark);
        break;
      default:
        selectedMode.value = ThemeModeSelection.system;
        Get.changeThemeMode(ThemeMode.system);
    }
  }

  void selectMode(ThemeModeSelection mode) {
    selectedMode.value = mode;
    String themeString;
    switch (mode) {
      case ThemeModeSelection.light:
        themeString = 'light';
        Get.changeThemeMode(ThemeMode.light);
        break;
      case ThemeModeSelection.dark:
        themeString = 'dark';
        Get.changeThemeMode(ThemeMode.dark);
        break;
      default:
        themeString = 'system';
        Get.changeThemeMode(ThemeMode.system);
    }
    storage.write('savedTheme', themeString);
  }

  void loadLanguage() {
    String lang =
        storage.read('language') ?? Get.deviceLocale?.languageCode ?? 'en';

    language.value = lang;

    Get.updateLocale(Locale(lang));
  }

  void setLanguage(String lang) {
    language.value = lang;

    Get.updateLocale(Locale(lang));

    storage.write('language', lang);
  }
}
