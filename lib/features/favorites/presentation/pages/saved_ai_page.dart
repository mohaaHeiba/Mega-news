import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/features/favorites/presentation/controller/favorites_controller.dart';
import 'package:mega_news/features/favorites/presentation/widgets/build_ai_summary_tile.dart';
import 'package:mega_news/features/favorites/presentation/widgets/build_empty_state_ai.dart';

class SavedAiPage extends GetView<FavoritesController> {
  const SavedAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.background,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 20),
            AppGaps.w8,
            Text(
              s.saved_ai_title,
              style: context.textStyles.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: context.primary),
          );
        }

        if (controller.aiSummaries.isEmpty) {
          return buildEmptyStateAi(context, s);
        }

        return RefreshIndicator(
          onRefresh: () async => await controller.loadFavorites(),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: controller.aiSummaries.length,
            separatorBuilder: (context, index) => AppGaps.h16,
            itemBuilder: (context, index) {
              final article = controller.aiSummaries[index];
              return buildAiSummaryTile(context, article, controller, s);
            },
          ),
        );
      }),
    );
  }
}
