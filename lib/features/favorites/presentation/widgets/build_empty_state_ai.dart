import 'package:flutter/material.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/generated/l10n.dart';

Widget buildEmptyStateAi(BuildContext context, S s) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.auto_awesome_motion,
            size: 60,
            color: Colors.purple.withOpacity(0.6),
          ),
        ),
        AppGaps.h24,
        Text(
          s.saved_ai_empty, // <--- تم التعديل
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    ),
  );
}
