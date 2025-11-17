import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/custom/snackbars/custom_snackbar.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/settings/presentations/controller/menu_view_controller.dart';

class AboutSection extends GetView<MenuViewController> {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final theme = context;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            s.about,
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
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(s.appVersion),
                trailing: Text(
                  controller.getAppVersion(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
              ),
              Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text(s.privacyPolicy),
                trailing: const Icon(Icons.chevron_right),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                onTap: () {
                  customSnackbar(
                    title: s.privacyPolicy,
                    message: 'Privacy policy page coming soon',
                    color: AppColors.primary,
                  );
                },
              ),
              Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(s.termsOfService),
                trailing: const Icon(Icons.chevron_right),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                onTap: () {
                  customSnackbar(
                    title: s.termsOfService,
                    message: 'Terms of service page coming soon',
                    color: AppColors.primary,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
