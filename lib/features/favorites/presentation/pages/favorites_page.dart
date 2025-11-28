import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/favorites/presentation/controller/favorites_controller.dart';
import 'package:mega_news/features/favorites/presentation/widgets/build_empty_state.dart'
    show buildEmptyState;
import 'package:mega_news/features/favorites/presentation/widgets/build_favorite_article_tile.dart';

class FavoritesPage extends GetView<FavoritesController> {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          s.savedArticles,
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: context.primary),
          );
        }

        if (controller.normalArticles.isEmpty) {
          return buildEmptyState(context, s);
        }

        return RefreshIndicator(
          color: context.primary,
          onRefresh: () async {
            await controller.loadFavorites();
          },
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: controller.normalArticles.length,
            separatorBuilder: (context, index) => AppGaps.h16,
            itemBuilder: (context, index) {
              final article = controller.normalArticles[index];

              return buildFavoriteArticleTile(context, article, controller, s);
            },
          ),
        );
      }),
    );
  }
}
