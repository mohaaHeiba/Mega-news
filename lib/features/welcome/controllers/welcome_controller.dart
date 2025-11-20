import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_images.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/services/permission_service.dart';

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

    final s = Get.context!.s; // Get localization

    pages = [
      {
        "title": s.welcomeTitle1,
        "subtitle": s.welcomeSubtitle1,
        "image": AppImages.newAggregation,
      },
      {
        "title": s.welcomeTitle2,
        "subtitle": s.welcomeSubtitle2,
        "image": AppImages.searchSummary,
      },
      {
        "title": s.welcomeTitle3,
        "subtitle": s.welcomeSubtitle3,
        "image": AppImages.favorite,
      },
      {
        "title": s.welcomeTitle4,
        "subtitle": s.welcomeSubtitle4,
        "image": AppImages.notifications,
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

  void goNext() {
    imageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
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
