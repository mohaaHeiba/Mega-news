import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/custom/custom_snackbar.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/settings/controller/menu_view_controller.dart';

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
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.pinkAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.pinkAccent,
                size: 22,
              ),
            ),
            title: Text(
              s.clearCache,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              s.clearCacheDescription,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.onSurface.withOpacity(0.6),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: theme.onSurface.withOpacity(0.4),
            ),
            onTap: () async {
              final confirmed = await Get.dialog<bool>(
                AlertDialog(
                  backgroundColor: theme.surface,
                  title: Text(s.clearCache),
                  content: Text(s.clearCacheDescription),
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
                      child: Text(
                        s.confirm,
                        style: TextStyle(color: theme.primary),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await controller.clearCache();
                await controller.deleteAllFavorites();

                customSnackbar(
                  title: Get.context!.s.cache_cleared_title,
                  message: Get.context!.s.cache_cleared_msg,
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
