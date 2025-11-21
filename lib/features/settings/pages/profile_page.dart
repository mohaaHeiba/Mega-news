import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/settings/controller/menu_view_controller.dart';
import 'package:mega_news/features/settings/widgets/profile_widgets/info_section.dart';
import 'package:mega_news/features/settings/widgets/profile_widgets/profile_section.dart';
import 'package:mega_news/features/settings/widgets/profile_widgets/quick_actions.dart';
import 'package:mega_news/features/settings/widgets/profile_widgets/stats_row.dart';

class ProfilePage extends GetView<MenuViewController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = context.s;

    return Scaffold(
      // backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: context.primary.withOpacity(0.5),

        elevation: 0,
        centerTitle: true,
        title: Text(
          s.profile,
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: context.primary.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.settings_rounded, color: context.primary),
              onPressed: () => controller.setPage(1),
            ),
          ),
        ],
      ),
      body: Obx(() {
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

        return Container(
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                ProfileHeader(theme, s, controller.user.value!),
                AppGaps.h24,
                StatsRow(theme, s),
                AppGaps.h24,
                QuickActions(theme, s),
                AppGaps.h24,
                InfoSection(theme, s, controller.user.value!),
                AppGaps.h24,
                AppGaps.h24,
              ],
            ),
          ),
        );
      }),
    );
  }
}
