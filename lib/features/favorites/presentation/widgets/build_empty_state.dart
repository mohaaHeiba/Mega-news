import 'package:flutter/material.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';

Widget buildEmptyState(BuildContext context, dynamic s) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: context.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.bookmark_border_rounded,
            size: 60,
            color: context.primary.withOpacity(0.6),
          ),
        ),
        AppGaps.h24,
        Text(
          s.noSavedArticles,
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.onSurface.withOpacity(0.8),
          ),
        ),
        AppGaps.h8,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            s.articlesYouSaveWillAppearHere,
            textAlign: TextAlign.center,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.onSurface.withOpacity(0.5),
            ),
          ),
        ),
      ],
    ),
  );
}
