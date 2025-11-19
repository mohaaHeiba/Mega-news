// 👇 1. التعديل الأول والأهم: استخدام hide SearchController
import 'package:flutter/material.dart' hide SearchController;

import 'package:get/get.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:mega_news/core/routes/app_pages.dart';
import 'package:mega_news/features/home/widgets/build_article_shimmer.dart';
import 'package:share_plus/share_plus.dart';

// 👇 2. تأكد من استيراد ملف الكنترولر الخاص بك (عدل المسار لو مختلف عندك)
import 'package:mega_news/features/search/presentations/controller/search_controller.dart';

class ShowSearchPage extends GetView<SearchController> {
  const ShowSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,

      floatingActionButton: Obx(() {
        if (controller.articles.isNotEmpty &&
            !controller.isLoading.value &&
            !controller.isSummarizing.value) {
          return FloatingActionButton.extended(
            onPressed: () => controller.summarizeSearchResults(),
            backgroundColor: context.primary,
            foregroundColor: Colors.white,
            label: const Text('Summarize Results'),
            icon: const Icon(Icons.auto_awesome_rounded),
          );
        } else if (controller.isSummarizing.value) {
          return FloatingActionButton(
            onPressed: () {},
            backgroundColor: context.onBackground.withOpacity(0.1),
            child: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 0,
              backgroundColor: context.background,
              floating: true,
              snap: true,
              pinned: false,
              expandedHeight: 0,
              toolbarHeight: 80,
              automaticallyImplyLeading: false,
              title: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Icon(
                        Icons.search_rounded,
                        color: context.onBackground.withOpacity(0.5),
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        // بما أننا صلحنا التعارض، هذا السطر سيعمل الآن
                        controller: controller.textController,
                        autofocus: true,
                        style: TextStyle(
                          fontSize: 16,
                          color: context.onBackground,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search news, topics...',
                          hintStyle: TextStyle(
                            color: context.onBackground.withOpacity(0.5),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.searchQuery.value.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color: context.onBackground.withOpacity(0.5),
                                size: 20,
                              ),
                              onPressed: () {
                                controller.clearSearch();
                              },
                            )
                          : const SizedBox.shrink(),
                    ),
                    Obx(
                      () => Container(
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: controller.isListening.value
                              ? Colors.redAccent.withOpacity(0.1)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            controller.isListening.value
                                ? Icons.mic_rounded
                                : Icons.mic_none_rounded,
                            color: controller.isListening.value
                                ? Colors.redAccent
                                : context.onBackground.withOpacity(0.5),
                            size: 24,
                          ),
                          onPressed: controller.isListening.value
                              ? controller.stopListening
                              : controller.startListening,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. المحتوى
            Obx(() {
              if (controller.isLoading.value) {
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => buildArticleShimmer(context),
                      childCount: 6,
                    ),
                  ),
                );
              }

              if (controller.articles.isEmpty &&
                  controller.textController.text.isNotEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 80,
                          color: context.onBackground.withOpacity(0.2),
                        ),
                        AppGaps.h16,
                        Text(
                          'No results found',
                          style: context.textStyles.headlineSmall?.copyWith(
                            color: context.onBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.articles.isEmpty &&
                  controller.textController.text.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: context.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.travel_explore_rounded,
                            size: 50,
                            color: context.primary,
                          ),
                        ),
                        AppGaps.h24,
                        Text(
                          'Discover News',
                          style: context.textStyles.headlineSmall?.copyWith(
                            color: context.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                          left: 4,
                          right: 4,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${controller.articles.length} Results',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: context.primary,
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              child: Text(
                                'for "${controller.searchQuery.value}"',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: context.onBackground.withOpacity(0.6),
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final itemIndex = index - 1;

                    if (itemIndex >= controller.articles.length) {
                      if (controller.isLoadingMore.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return const SizedBox.shrink();
                    }

                    if (itemIndex >= controller.articles.length - 3 &&
                        !controller.isLoadingMore.value &&
                        controller.hasMorePages.value) {
                      controller.loadMore();
                    }

                    final article = controller.articles[itemIndex];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(
                              AppPages.articleDetailPage,
                              arguments: article,
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (article.imageUrl != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        article.imageUrl ?? '',
                                        width: 100,
                                        height: 75,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 100,
                                          height: 75,
                                          color: context.primary.withOpacity(
                                            0.1,
                                          ),
                                          child: Icon(
                                            Icons.image_not_supported_rounded,
                                            color: context.primary.withOpacity(
                                              0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (article.imageUrl != null) AppGaps.h12,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              AppGaps.h12,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 14,
                                        color: context.primary.withOpacity(0.8),
                                      ),
                                      AppGaps.h4,
                                      Text(
                                        controller.getTimeAgo(
                                          article.publishedAt,
                                        ),
                                        style: context.textStyles.labelMedium
                                            ?.copyWith(
                                              color: context.primary
                                                  .withOpacity(0.8),
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.share_rounded,
                                          size: 20,
                                          color: context.onBackground
                                              .withOpacity(0.5),
                                        ),
                                        onPressed: () {
                                          Share.share(
                                            "${article.title}\n${article.articleUrl}",
                                          );
                                        },
                                      ),
                                      Obx(
                                        () => IconButton(
                                          icon: Icon(
                                            controller.isLiked.value
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: controller.isLiked.value
                                                ? Colors.redAccent
                                                : context.onBackground
                                                      .withOpacity(0.5),
                                            size: 18,
                                          ),
                                          onPressed: () =>
                                              controller.isLiked.toggle(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              AppGaps.h8,
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
                  }, childCount: controller.articles.length + 2),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
