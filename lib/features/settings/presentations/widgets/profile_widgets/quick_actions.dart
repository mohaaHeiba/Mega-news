import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/features/favorites/presentation/pages/favorites_page.dart';

// ignore: non_constant_identifier_names
Widget QuickActions(ThemeData theme, dynamic s) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 12),
        child: Text(
          'Quick Actions',
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
            _buildActionTile(
              theme,
              icon: Icons.bookmark_outline_rounded,
              color: Colors.purpleAccent,
              title: s.savedArticles,
              onTap: () => Get.to(() => const FavoritesPage()),
            ),
            // يمكنك إضافة المزيد هنا مستقبلاً
          ],
        ),
      ),
    ],
  );
}

Widget _buildActionTile(
  ThemeData theme, {
  required IconData icon,
  required Color color,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 22),
    ),
    title: Text(
      title,
      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16,
      color: theme.colorScheme.onSurface.withOpacity(0.4),
    ),
  );
}
