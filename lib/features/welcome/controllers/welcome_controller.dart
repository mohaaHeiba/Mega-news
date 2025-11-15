import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/services/permission_service.dart';
import 'package:mega_news/generated/l10n.dart';

class WelcomeController extends GetxController {
  final PermissionService permission = Get.find<PermissionService>();
  // Controllers for PageViews
  final PageController imageController = PageController();
  final PageController textController = PageController();

  // Current page index
  final currentIndex = 0.obs;

  // Flag to show content after a short delay
  var showContent = false.obs;

  late final List<Map<String, String>> pages;
  @override
  void onInit() {
    super.onInit();

    final s = S.of(Get.context!); // Get localization

    pages = [
      {
        "title": s.welcomeTitle1,
        "subtitle": s.welcomeSubtitle1,
        "image": "assets/images/news_aggregation.png",
      },
      {
        "title": s.welcomeTitle2,
        "subtitle": s.welcomeSubtitle2,
        "image": "assets/images/search_summary.png",
      },
      {
        "title": s.welcomeTitle3,
        "subtitle": s.welcomeSubtitle3,
        "image": "assets/images/favorites.png",
      },
      {
        "title": s.welcomeTitle4,
        "subtitle": s.welcomeSubtitle4,
        "image": "assets/images/notifications.png",
      },
    ];

    // Delay showing content for a smooth animation
    Future.delayed(const Duration(milliseconds: 300), () {
      showContent.value = true;
    });
  }

  /// Called when page changes

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  // GET PREMESSIONS
  Future<void> requestPermissions() async {
    await permission.requestAll();
  }

  @override
  void onClose() {
    imageController.dispose();
    textController.dispose();
    super.onClose();
  }
}
