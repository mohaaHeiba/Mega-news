import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';

import 'package:mega_news/features/settings/presentations/controller/theme_controller.dart';

class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key});

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
            s.theme,
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
          child: Row(
            children: [
              Expanded(
                child: _ThemeOption(
                  label: s.light,
                  mode: ThemeModeSelection.light,
                  icon: Icons.wb_sunny,
                ),
              ),
              Expanded(
                child: _ThemeOption(
                  label: s.dark,
                  mode: ThemeModeSelection.dark,
                  icon: Icons.nightlight_round,
                ),
              ),
              Expanded(
                child: _ThemeOption(
                  label: s.system,
                  mode: ThemeModeSelection.system,
                  icon: Icons.brightness_auto,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final ThemeModeSelection mode;
  final IconData icon;

  const _ThemeOption({
    required this.label,
    required this.mode,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => controller.selectMode(mode),
      borderRadius: BorderRadius.circular(12),

      child: Obx(() {
        final isSelected = controller.selectedMode.value == mode;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                size: 28,
              ),
              AppGaps.h8,
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
