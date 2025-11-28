import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/auth/data/model/auth_model.dart';
import 'package:mega_news/features/auth/domain/entity/auth_entity.dart';
import 'package:mega_news/features/auth/presentations/controller/auth_controller.dart';
import 'package:mega_news/features/favorites/data/repositories/favorites_repository.dart';
import 'package:mega_news/features/favorites/domain/usecases/clear_all_favorites_use_case.dart';
import 'package:mega_news/features/settings/controller/theme_controller.dart';
import 'package:mega_news/core/services/permission_service.dart';

class MenuViewController extends GetxController {
  final storage = GetStorage();
  final Rxn<AuthEntity> user = Rxn<AuthEntity>();
  final ThemeController themeController = Get.find<ThemeController>();

  final PermissionService _permissionService = PermissionService();

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
  final notificationsEnabled = false.obs;
  final breakingNewsEnabled = true.obs;

  String get currentLang => themeController.language.value;
  bool get isArabic => themeController.language.value == 'ar';

  @override
  void onInit() {
    super.onInit();
    _loadOtherSettings();
    _initializeUser();

    _checkSystemPermissions();
  }

  Future<void> _checkSystemPermissions() async {
    bool systemGranted = await _permissionService.isNotificationGranted;
    bool userPref = storage.read('notifications') ?? true;

    if (!systemGranted) {
      notificationsEnabled.value = false;
    } else {
      notificationsEnabled.value = userPref;
    }
  }

  void _initializeUser() {
    try {
      final AuthController authController = Get.find<AuthController>();
      ever(authController.user, (authUser) {
        if (authUser != null) {
          user.value = authUser;
          Future.delayed(const Duration(milliseconds: 100), () => loadUser());
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

  Future<void> toggleNotifications() async {
    if (notificationsEnabled.value) {
      notificationsEnabled.value = false;
      storage.write('notifications', false);
      return;
    }

    bool granted = await _permissionService.requestNotification();

    if (granted) {
      notificationsEnabled.value = true;
      storage.write('notifications', true);
    } else {
      _showPermissionDialog();
      notificationsEnabled.value = false;
    }
  }

  void toggleBreakingNews() async {
    if (!breakingNewsEnabled.value) {
      if (!notificationsEnabled.value) {
        await toggleNotifications();
        if (!notificationsEnabled.value) return;
      }
    }

    breakingNewsEnabled.value = !breakingNewsEnabled.value;
    storage.write('breakingNews', breakingNewsEnabled.value);
  }

  void _showPermissionDialog() {
    final s = Get.context!.s;

    Get.defaultDialog(
      title: s.notification_permission_title,
      middleText: s.notification_permission_msg,
      textConfirm: s.action_settings,
      textCancel: s.action_cancel,
      confirmTextColor: Colors.white,
      onConfirm: () {
        _permissionService.openSettings();
        Get.back();
      },
    );
  }

  void changeLanguage(String lang) {
    themeController.setLanguage(lang);
  }

  Future<void> clearCache() async {
    final keptData = <String, dynamic>{
      'favorites_cache': storage.read('favorites_cache'),
    };

    await storage.erase();

    keptData.forEach((key, value) {
      if (value != null) storage.write(key, value);
    });

    themeController.loadTheme();
    themeController.loadLanguage();
  }

  Future<void> deleteAllFavorites() async {
    final currentUser = user.value;
    final userId = currentUser?.id ?? 'guest';

    try {
      final favoritesRepo = Get.find<FavoritesRepository>();

      final clearUseCase = ClearAllFavoritesUseCase(favoritesRepo);

      // Call the use case with userId
      await clearUseCase.call(userId);

      Get.snackbar(
        'Success',
        'All favorites cleared successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error clearing favorites: $e'); // Debug print
      Get.snackbar(
        'Error',
        'Failed to clear favorites',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> logout() async {
    await storage.erase();
    await Get.offAllNamed(AppPages.welcomePage);
  }

  String getAppVersion() => '1.0.0';
}
