import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/home/widgets/build_article_shimmer.dart';
import 'package:share_plus/share_plus.dart';

Widget buildArticlesList(final controller, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: controller.isLoading.value
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (_, __) => AppGaps.h4,
            itemBuilder: (_, __) => buildArticleShimmer(context),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (controller.articles.length > 5)
                ? controller.articles.length - 5
                : 0,
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemBuilder: (_, index) {
              final article = controller.articles[index + 5];

              // ... (Article Item Code from the last refined version) ...
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(AppPages.articleDetailPage, arguments: article);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Article Image (Prominent, Left Side, Ratio 4:3)
                            if (article.imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  article.imageUrl ?? '',
                                  width: 100,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 100,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: context.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.image_not_supported_rounded,
                                      color: context.primary.withOpacity(0.5),
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),

                            if (article.imageUrl != null)
                              const SizedBox(width: 12),

                            // 2. Article Content (Right Side - Title is the Focus)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.title,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.textStyles.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          height: 1.3,
                                          color: context.onBackground,
                                        ),
                                  ),

                                  // Source Name (Immediately below the title, low contrast)
                                  AppGaps.h4,
                                  Text(
                                    article.sourceName,
                                    style: context.textStyles.labelMedium
                                        ?.copyWith(
                                          color: context.onBackground
                                              .withOpacity(0.6),
                                          fontWeight: FontWeight.w500,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // 3. Bottom Metadata & Actions Row (Cleaned up, full width)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: context.primary.withOpacity(0.8),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  controller.getTimeAgo(article.publishedAt),
                                  style: context.textStyles.labelMedium
                                      ?.copyWith(
                                        color: context.primary.withOpacity(0.8),
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),

                            // Actions (Grouped, using IconButton for better tap area)
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.share_rounded,
                                    size: 20,
                                    color: context.onBackground.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                  onPressed: () {
                                    Share.share(
                                      "${article.title}\n${article.articleUrl}",
                                    );
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    controller.isLiked.value
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: controller.isLiked.value
                                        ? Colors.redAccent
                                        : Colors.white,
                                    size: 18,
                                  ),
                                  onPressed: () => controller.isLiked.toggle(),

                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Divider to separate items
                        // const SizedBox(height: 8),
                        Divider(
                          color: context.onBackground.withOpacity(0.1),
                          height: 1,
                          thickness: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
  );
}
