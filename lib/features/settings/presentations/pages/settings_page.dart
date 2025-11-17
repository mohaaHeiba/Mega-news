import 'package:flutter/material.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/settings/presentations/widgets/settings_widgets/about_section.dart';
import 'package:mega_news/features/settings/presentations/widgets/settings_widgets/language_section.dart';
import 'package:mega_news/features/settings/presentations/widgets/settings_widgets/logout_button.dart';
import 'package:mega_news/features/settings/presentations/widgets/settings_widgets/notifications_section.dart';
import 'package:mega_news/features/settings/presentations/widgets/settings_widgets/storage_sections.dart';
import 'package:mega_news/features/settings/presentations/widgets/settings_widgets/theme_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.primary.withOpacity(0.5),
        elevation: 0,
        title: Text(s.settings),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.primary.withOpacity(0.5),
              context.background,
              context.background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
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
            AppGaps.h16,
          ],
        ),
      ),
    );
  }
}
