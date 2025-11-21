import 'package:flutter/material.dart' hide SearchController;
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';

Widget buildEmptyState(
  BuildContext context, {
  required IconData icon,
  required String message,
  Color? iconColor,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: (iconColor ?? context.onBackground).withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 60,
            color: (iconColor ?? context.onBackground).withOpacity(0.5),
          ),
        ),
        AppGaps.h24,
        Text(
          message,
          style: context.textStyles.headlineSmall?.copyWith(
            color: context.onBackground.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
