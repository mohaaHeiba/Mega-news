import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum ThemeModeSelection { light, dark, system }

class ThemeController extends GetxController {
  final storage = GetStorage();
  final Rx<ThemeModeSelection> selectedMode = ThemeModeSelection.system.obs;
  final language = 'en'.obs;

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

  void _loadOtherSettings() {
    final savedLang = storage.read('language');
    if (savedLang != null) {
      language.value = savedLang;
    } else {
      final deviceLang = Get.deviceLocale?.languageCode;

      if (deviceLang == 'ar') {
        language.value = 'ar';
      } else {
        language.value = 'en';
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadTheme();
    _loadOtherSettings();
  }
}
