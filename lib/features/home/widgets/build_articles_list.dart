import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/favorites/presentation/controller/favorites_controller.dart';
import 'package:mega_news/features/home/widgets/build_article_shimmer.dart';
import 'package:share_plus/share_plus.dart';

Widget buildArticlesList(
  final controller,
  BuildContext context, {
  bool skipFirstFive = true,
}) {
  final favoritesController = Get.find<FavoritesController>();

  final int skipCount = skipFirstFive ? 5 : 0;

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
            itemCount: (controller.articles.length > skipCount)
                ? controller.articles.length - skipCount
                : 0,
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemBuilder: (_, index) {
              final article = controller.articles[index + skipCount];

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
                            // 1. Article Image
                            if (article.imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: article.imageUrl!,
                                  width: 100,
                                  height: 90,
                                  fit: BoxFit.cover,

                                  placeholder: (context, url) => Container(
                                    width: 100,
                                    height: 90,
                                    color: context.surface.withOpacity(0.1),
                                  ),

                                  errorWidget: (context, url, error) =>
                                      Container(
                                        width: 100,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          color: context.primary.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.image_not_supported_rounded,
                                          color: context.primary.withOpacity(
                                            0.5,
                                          ),
                                          size: 30,
                                        ),
                                      ),
                                ),
                              ),

                            if (article.imageUrl != null) AppGaps.w12,

                            // 2. Article Content
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

                        // 3. Bottom Metadata & Actions Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Time
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: context.primary.withOpacity(0.8),
                                ),
                                AppGaps.w4,
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

                            // Actions
                            Row(
                              children: [
                                // Share Button
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

                                // Favorite Button
                                Obx(() {
                                  final isFav = favoritesController.isFavorite(
                                    article.id,
                                  );

                                  return IconButton(
                                    icon: Icon(
                                      isFav
                                          ? Icons.bookmark_rounded
                                          : Icons.bookmark_border_rounded,
                                      color: isFav
                                          ? Colors.redAccent
                                          : context.onBackground.withOpacity(
                                              0.5,
                                            ),
                                      size: 20,
                                    ),
                                    onPressed: () => favoritesController
                                        .toggleFavorite(article),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 32,
                                      minHeight: 32,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),

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
