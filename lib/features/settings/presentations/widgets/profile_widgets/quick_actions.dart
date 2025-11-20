import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mega_news/features/favorites/presentation/pages/favorites_page.dart';

// ignore: non_constant_identifier_names
Widget QuickActions(ThemeData theme, dynamic s) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 12),
        child: Text(
          'Quick Actions', // (أو s.quickActions)
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.bookmark_border),
              title: Text(s.savedArticles),
              trailing: Icon(Icons.chevron_right),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              onTap: () {
                Get.to(FavoritesPage());
              },
            ),
          ],
        ),
      ),
    ],
  );
}
