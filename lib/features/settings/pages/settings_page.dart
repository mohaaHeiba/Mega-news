import 'package:flutter/material.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/settings/widgets/settings_widgets/about_section.dart';
import 'package:mega_news/features/settings/widgets/settings_widgets/language_section.dart';
import 'package:mega_news/features/settings/widgets/settings_widgets/logout_button.dart';
import 'package:mega_news/features/settings/widgets/settings_widgets/notifications_section.dart';
import 'package:mega_news/features/settings/widgets/settings_widgets/storage_sections.dart';
import 'package:mega_news/features/settings/widgets/settings_widgets/theme_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.background,

        elevation: 0,
        title: Text(
          s.settings,
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const ThemeSection(),
          AppGaps.h24,
          const LanguageSection(),
          AppGaps.h24,
          const NotificationsSection(),
          AppGaps.h24,
          const StorageSection(),
          AppGaps.h24,
          const AboutSection(),
          AppGaps.h32,
          const LogoutButton(),
          AppGaps.h32,
        ],
      ),
    );
  }
}
