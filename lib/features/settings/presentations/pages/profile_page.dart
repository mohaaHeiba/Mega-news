import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/constants/app_images.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/settings/presentations/controller/menu_view_controller.dart';
import 'package:mega_news/features/settings/presentations/widgets/profile_widgets/info_section.dart';
import 'package:mega_news/features/settings/presentations/widgets/profile_widgets/profile_section.dart';
import 'package:mega_news/features/settings/presentations/widgets/profile_widgets/quick_actions.dart';
import 'package:mega_news/features/settings/presentations/widgets/profile_widgets/stats_row.dart';

class ProfilePage extends GetView<MenuViewController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = context.s;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.primary.withOpacity(0.5),
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 12),
            Image.asset(AppImages.logo, height: 40),
            const SizedBox(width: 12),
            Text(
              s.profile,
              style: context.textStyles.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: context.primary.withOpacity(0.6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: s.settings,
              onPressed: () {
                controller.setPage(1);
              },
            ),
          ),
        ],
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
        child: Obx(() {
          if (controller.user.value == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: context.primary),
                  const SizedBox(height: 16),
                  Text(s.noUserDataFound),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppGaps.h8,
              ProfileHeader(theme, s, controller.user.value!),
              AppGaps.h24,
              StatsRow(theme, s),
              AppGaps.h24,
              InfoSection(theme, s, controller.user.value!),
              AppGaps.h16,
              QuickActions(theme, s),
              AppGaps.h16,
            ],
          );
        }),
      ),
    );
  }
}
