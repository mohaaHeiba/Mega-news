import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/settings/presentations/controller/menu_view_controller.dart';

class NotificationsSection extends StatelessWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MenuViewController>();
    final s = context.s;
    final theme = context;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            s.notifications,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Obx(
            () => Column(
              children: [
                SwitchListTile(
                  value: controller.notificationsEnabled.value,
                  onChanged: (value) {
                    controller.toggleNotifications();
                  },
                  title: Text(s.enableNotifications),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                ),
                Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  value: controller.breakingNewsEnabled.value,
                  onChanged: (value) {
                    controller.toggleBreakingNews();
                  },
                  title: Text(s.enableBreakingNews),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
