import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/favorites/presentation/controller/favorites_controller.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:mega_news/generated/l10n.dart';
import 'package:timeago/timeago.dart' as timeago;

class FavoritesPage extends GetView<FavoritesController> {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          s.savedArticles,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.favorites.isEmpty) {
          return _buildEmptyState(theme, s);
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.loadFavorites();
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.favorites.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 12), // AppConst.h12
            itemBuilder: (context, index) {
              final article = controller.favorites[index];
              return _buildFavoriteArticleTile(
                context,
                article,
                controller,
                theme,
                s,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(ThemeData theme, S s) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            s.noSavedArticles,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              s.articlesYouSaveWillAppearHere,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
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
    ThemeData theme,
    S s,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.toNamed(AppPages.articleDetailPage, arguments: article);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: article.id,
                  child: Image.network(
                    article.imageUrl ?? '',
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, __) => Container(
                      width: 110,
                      height: 110,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Article Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (article.description != null) ...[
                      Text(
                        article.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeago.format(article.publishedAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Favorite Button
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () => controller.removeFavorite(article),
                tooltip: s.removeFromFavorites,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
