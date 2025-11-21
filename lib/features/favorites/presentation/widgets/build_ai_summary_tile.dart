import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/favorites/presentation/controller/favorites_controller.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:mega_news/generated/l10n.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget buildAiSummaryTile(
  BuildContext context,
  Article article,
  FavoritesController controller,
  S s,
) {
  return Container(
    decoration: BoxDecoration(
      color: context.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.purple.withOpacity(0.2), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.purple.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Get.toNamed(AppPages.articleDetailPage, arguments: article);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 12,
                        ),
                        AppGaps.w4,
                        Text(
                          s.saved_ai_badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    timeago.format(
                      article.publishedAt,
                      locale: Get.locale?.languageCode ?? 'en',
                    ),
                    style: context.textStyles.labelSmall?.copyWith(
                      color: context.onSurface.withOpacity(0.5),
                    ),
                  ),
                  AppGaps.w8,
                  IconButton(
                    onPressed: () => controller.removeFavorite(article),
                    icon: const Icon(Icons.bookmark_remove_rounded),
                    color: Colors.redAccent,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 20,
                  ),
                ],
              ),
              AppGaps.h12,
              Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),

              AppGaps.h8,

              Text(
                article.description ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.bodyMedium?.copyWith(
                  color: context.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
