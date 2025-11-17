import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:mega_news/features/settings/presentations/controller/menu_view_controller.dart';
import 'package:mega_news/features/settings/presentations/pages/profile_page.dart';
import 'package:mega_news/features/settings/presentations/pages/settings_page.dart';

class MenuView extends GetView<MenuViewController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        children: const [SettingsPage(), ProfilePage()],
      ),
    );
  }
}
