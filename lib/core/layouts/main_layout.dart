import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/layouts/bottom_nav_bar.dart';
import 'package:mega_news/core/layouts/layout_controller.dart';
import 'package:mega_news/features/briefing/pages/briefing_page.dart';
import 'package:mega_news/features/home/pages/home_page.dart';
import 'package:mega_news/features/settings/pages/menu_view.dart';

class MainLayout extends GetView<LayoutController> {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(LayoutController());

    final pages = const [HomePage(), AiBriefingPage(), MenuView()];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
