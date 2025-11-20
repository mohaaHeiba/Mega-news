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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            s.about,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildAboutTile(
                theme,
                icon: Icons.info_outline_rounded,
                iconColor: Colors.blue,
                title: s.appVersion,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.getAppVersion(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  height: 1,
                  color: theme.dividerColor.withOpacity(0.1),
                ),
              ),
              _buildAboutTile(
                theme,
                icon: Icons.privacy_tip_outlined,
                iconColor: Colors.purple,
                title: s.privacyPolicy,
                onTap: () {
                  customSnackbar(
                    title: s.privacyPolicy,
                    message: 'Privacy policy page coming soon',
                    color: AppColors.primary,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  height: 1,
                  color: theme.dividerColor.withOpacity(0.1),
                ),
              ),
              _buildAboutTile(
                theme,
                icon: Icons.description_outlined,
                iconColor: Colors.orange,
                title: s.termsOfService,
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

  Widget _buildAboutTile(
    ThemeData theme, {
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
    );
  }
}
