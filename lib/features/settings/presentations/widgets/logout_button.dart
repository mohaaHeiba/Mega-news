import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/settings/presentations/controller/menu_view_controller.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MenuViewController>();
    final s = context.s;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () async {
          final confirmed = await Get.dialog<bool>(
            AlertDialog(
              title: Text(s.logout),
              content: Text(s.logoutConfirmation),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: Text(s.cancel),
                ),
                TextButton(
                  onPressed: () => Get.back(result: true),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: Text(s.confirm),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            controller.logout();
          }
        },
        icon: const Icon(Icons.logout),
        label: Text(s.logout),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
