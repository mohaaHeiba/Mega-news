import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/layouts/layout_controller.dart';

class BottomNavBar extends GetView<LayoutController> {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<LayoutController>();
    final theme = context;
    final s = context.s;
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: theme.colors.shadow.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: BottomNavigationBar(
              backgroundColor: theme.background,
              elevation: 0,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTab,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: theme.onSurface.withOpacity(0.6),
              showSelectedLabels: true,
              showUnselectedLabels: false,
              items: [
                _navItem(
                  index: 0,
                  controller: controller,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: s.home,
                ),

                _navItem(
                  index: 1,
                  controller: controller,
                  icon: Icons.auto_awesome_outlined,
                  activeIcon: Icons.auto_awesome_rounded,
                  label: s.briefing,
                ),

                _navItem(
                  index: 2,
                  controller: controller,
                  icon: Icons.menu_rounded,
                  activeIcon: Icons.menu_open_rounded,
                  label: s.menu,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem({
    required int index,
    required LayoutController controller,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = controller.currentIndex.value == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Icon(isActive ? activeIcon : icon, size: isActive ? 30 : 26),
      ),
      label: label,
    );
  }
}
