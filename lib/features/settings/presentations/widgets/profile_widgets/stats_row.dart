import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/features/favorites/presentation/controller/favorites_controller.dart';

// ignore: non_constant_identifier_names
Widget StatsRow(ThemeData theme, dynamic s) {
  // بنوصل للكنترولر عشان نجيب الأرقام الحقيقية
  final favoritesController = Get.find<FavoritesController>();

  return Row(
    children: [
      // --- Saved Articles Card (Normal News) ---
      Expanded(
        child: _buildStatCard(
          theme,
          title: s.savedArticles, // "Saved Articles"
          icon: Icons.article_rounded,
          iconColor: Colors.orangeAccent,
          valueWidget: Obx(
            // ✅ بنعرض عدد الأخبار العادية فقط
            () => Text(
              '${favoritesController.normalArticles.length}',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
      AppGaps.w16,

      // --- AI Summaries Card (New) ---
      Expanded(
        child: _buildStatCard(
          theme,
          title: "AI Summaries", // ممكن تضيفها للترجمة s.aiSummaries
          icon: Icons.auto_awesome_rounded, // أيقونة مناسبة للـ AI
          iconColor: Colors.purpleAccent,
          valueWidget: Obx(
            // ✅ بنعرض عدد ملخصات الذكاء الاصطناعي
            () => Text(
              '${favoritesController.aiSummaries.length}',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildStatCard(
  ThemeData theme, {
  required String title,
  required IconData icon,
  required Color iconColor,
  required Widget valueWidget,
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        AppGaps.h16,
        valueWidget,
        AppGaps.h4,
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
