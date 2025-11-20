import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/settings/presentations/controller/menu_view_controller.dart';

class LogoutButton extends GetView<MenuViewController> {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final theme = context;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () async {
          final confirmed = await Get.dialog<bool>(
            AlertDialog(
              backgroundColor: theme.surface,
              title: Text(s.logout),
              content: Text(s.logoutConfirmation),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: Text(
                    s.cancel,
                    style: TextStyle(color: theme.onSurface),
                  ),
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
        icon: const Icon(Icons.logout_rounded),
        label: Text(
          s.logout,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
