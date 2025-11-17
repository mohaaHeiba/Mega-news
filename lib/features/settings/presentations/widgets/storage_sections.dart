import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/custom/snackbars/custom_snackbar.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/settings/presentations/controller/menu_view_controller.dart';

class StorageSection extends StatelessWidget {
  const StorageSection({super.key});

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
            s.general,
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
          child: ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(s.clearCache),
            subtitle: Text(
              s.clearCacheDescription,
              style: theme.textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            onTap: () async {
              final confirmed = await Get.dialog<bool>(
                AlertDialog(
                  title: Text(s.clearCache),
                  content: Text(s.clearCacheDescription),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: Text(s.cancel),
                    ),
                    TextButton(
                      onPressed: () => Get.back(result: true),
                      child: Text(s.confirm),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await controller.clearCache();
                customSnackbar(
                  title: 'Cache Cleared',
                  message: 'Cache has been cleared successfully',
                  color: AppColors.success,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
