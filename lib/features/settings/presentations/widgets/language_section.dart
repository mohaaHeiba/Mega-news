import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/settings/presentations/controller/menu_view_controller.dart';

class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

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
            s.language,
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
                child: _LanguageOption(label: s.english, code: 'en'),
              ),
              Expanded(
                child: _LanguageOption(label: s.arabic, code: 'ar'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageOption extends GetView<MenuViewController> {
  final String label;
  final String code;
  const _LanguageOption({required this.label, required this.code});

  @override
  Widget build(BuildContext context) {
    final theme = context;
    final isSelected = controller.language.value == code;

    return InkWell(
      onTap: () => controller.setLanguage(code),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? theme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : theme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
