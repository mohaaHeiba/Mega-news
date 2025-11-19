import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/auth/data/model/auth_model.dart';
import 'package:mega_news/features/auth/domain/entity/auth_entity.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';

enum ThemeModeSelection { light, dark, system }

class MenuViewController extends GetxController {
  final storage = GetStorage();
  final Rxn<AuthEntity> user = Rxn<AuthEntity>();

  //=============== PageView ================
  final PageController pageController = PageController(initialPage: 0);
  final currentPage = 0.obs;

  void onPageChanged(int index) => currentPage.value = index;

  void setPage(int index) {
    currentPage.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  //=============== Settings ================

  final notificationsEnabled = true.obs;
  final breakingNewsEnabled = true.obs;
  final language = 'en'.obs;

  final loginBefore = false.obs; // بدل bool عادي

  @override
  void onInit() {
    super.onInit();

    _loadOtherSettings();
    _applyLocale();
    _initializeUser();
  }

  void _initializeUser() {
    try {
      final AuthController authController = Get.find<AuthController>();

      ever(authController.user, (authUser) {
        if (authUser != null) {
          user.value = authUser;
          Future.delayed(const Duration(milliseconds: 100), () {
            loadUser();
          });
        } else {
          user.value = null;
        }
      });

      if (authController.user.value != null) {
        user.value = authController.user.value;
      } else {
        loadUser();
      }
    } catch (e) {
      loadUser();
    }
  }

  Future<void> loadUser() async {
    try {
      final dynamic rawData = storage.read('auth_data');

      if (rawData != null && rawData is Map<String, dynamic>) {
        user.value = AuthModel.fromMap(rawData);
      } else {
        user.value = null;
      }
    } catch (e) {
      storage.remove('auth_data');
    }
  }

  void _loadOtherSettings() {
    notificationsEnabled.value = storage.read('notifications') ?? true;
    breakingNewsEnabled.value = storage.read('breakingNews') ?? true;
  }

  void _applyLocale() {
    final locale = Locale(language.value);
    Get.updateLocale(locale);
  }

  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
    storage.write('notifications', notificationsEnabled.value);
  }

  void toggleBreakingNews() {
    breakingNewsEnabled.value = !breakingNewsEnabled.value;
    storage.write('breakingNews', breakingNewsEnabled.value);
  }

  void setLanguage(String lang) {
    language.value = lang;
    storage.write('language', lang);
    _applyLocale();
  }

  bool get isArabic => language.value == 'ar';

  Future<void> clearCache() async {
    final keptData = <String, dynamic>{
      'savedTheme': storage.read('savedTheme'),
      'language': storage.read('language'),
      'notifications': storage.read('notifications'),
      'breakingNews': storage.read('breakingNews'),
    };

    await storage.erase();

    keptData.forEach((key, value) {
      if (value != null) {
        storage.write(key, value);
      }
    });
  }

  Future<void> logout() async {
    await storage.erase();
    await Get.offAllNamed(AppPages.welcomePage);
  }

  String getAppVersion() {
    return '1.0.0';
  }
}
