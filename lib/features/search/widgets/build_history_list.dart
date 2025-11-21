import 'package:flutter/material.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';

Widget buildHistoryList(BuildContext context, var s, final controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Header Row
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              s.search_recent,
              style: context.textStyles.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.onBackground,
              ),
            ),
            TextButton(
              onPressed: controller.clearAllHistory,
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: Text(s.search_clear_all),
            ),
          ],
        ),
      ),

      // History Items
      ...controller.searchHistory.map((item) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          leading: Icon(
            Icons.history_rounded,
            color: context.onBackground.withOpacity(0.5),
            size: 22,
          ),
          title: Text(
            item,
            style: TextStyle(fontSize: 16, color: context.onBackground),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: context.onBackground.withOpacity(0.4),
              size: 20,
            ),
            onPressed: () => controller.removeFromHistory(item),
          ),
          onTap: () => controller.searchFromHistory(item),
        );
      }),
      AppGaps.h24,
    ],
  );
}
