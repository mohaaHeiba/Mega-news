import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/favorites/presentation/controller/favorites_controller.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:timeago/timeago.dart' as timeago;

class FavoritesPage extends GetView<FavoritesController> {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.primary.withOpacity(0.5),
        elevation: 0,
        centerTitle: true,
        title: Text(
          s.savedArticles,
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.primary.withOpacity(0.5),
              context.background,
              context.background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: context.primary),
            );
          }

          if (controller.favorites.isEmpty) {
            return _buildEmptyState(context, s);
          }

          return RefreshIndicator(
            color: context.primary,
            onRefresh: () async {
              await controller.loadFavorites();
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: controller.favorites.length,
              separatorBuilder: (context, index) => AppGaps.h16,
              itemBuilder: (context, index) {
                final article = controller.favorites[index];
                return _buildFavoriteArticleTile(
                  context,
                  article,
                  controller,
                  s,
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, dynamic s) {
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
          const SizedBox(height: 24),
          Text(
            s.noSavedArticles,
            style: context.textStyles.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
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

  Widget _buildFavoriteArticleTile(
    BuildContext context,
    Article article,
    FavoritesController controller,
    dynamic s,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المقال
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Hero(
                    tag: 'fav_${article.id}', // تاج مميز للمفضلة
                    child: CachedNetworkImage(
                      imageUrl: article.imageUrl ?? '',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 100,
                        height: 100,
                        color: context.surface.withOpacity(0.1),
                        child: Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.primary,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 100,
                        color: context.surface.withOpacity(0.1),
                        child: Icon(
                          Icons.broken_image_rounded,
                          color: context.onSurface.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // محتوى المقال
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              article.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.textStyles.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                          // زر الحذف
                          IconButton(
                            onPressed: () => controller.removeFavorite(article),
                            icon: const Icon(Icons.bookmark_remove_rounded),
                            color: Colors.redAccent,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            iconSize: 24,
                            tooltip: s.removeFromFavorites,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (article.sourceName.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: context.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            article.sourceName,
                            style: context.textStyles.labelSmall?.copyWith(
                              color: context.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: context.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeago.format(article.publishedAt),
                            style: context.textStyles.labelSmall?.copyWith(
                              color: context.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
